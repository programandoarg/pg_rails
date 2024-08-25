# frozen_string_literal: true

module PgEngine
  class FiltrosBuilder
    include ActionView::Helpers
    include ActionView::Context
    include PostgresHelper
    attr_accessor :controller

    # El orden de los sufijos es importante
    SUFIJOS = %w[
      desde
      hasta
      gteq
      gt
      lteq
      lt
      incluye
      es_igual_a
      in
      cont_all
      cont_any
      not_cont
      cont
      eq
    ].freeze

    def initialize(controller, clase_modelo, campos)
      @clase_modelo = clase_modelo
      @filtros = {}
      @campos = campos.map do |campo|
        if extraer_sufijo(campo).blank?
          case tipo(campo)
          when :enumerized, :boolean
            :"#{campo}_eq"
          when :asociacion
            :"#{campo.to_s.sub(/_id$/, '')}_id_eq"
          when :date, :datetime
            [:"#{campo}_gteq", :"#{campo}_lteq"]
          else
            :"#{campo}_cont_all"
          end
        else
          campo
        end
      end.flatten
      @controller = controller
      @campos.each { |campo| @filtros[campo] = {} }
    end

    def opciones(campo, opciones)
      # TODO: mergear
      @filtros[campo] = opciones
    end

    # querys customizadas por campo
    def query(campo, &block)
      @filtros[campo] = {} if @filtros[campo].nil?
      @filtros[campo][:query] = block
    end

    def scope_asociacion(campo, &block)
      @filtros[campo] = {} if @filtros[campo].nil?
      @filtros[campo][:scope_asociacion] = block
    end

    # FIXME: deprecar
    def filtrar(query, parametros = nil)
      parametros_controller if parametros.nil?

      # Filtro soft deleted
      query = query.kept if query.respond_to?(:kept)

      query
    end

    def tipo(campo)
      nombre_campo = sin_sufijo(campo)

      if @filtros[nombre_campo.to_sym].present? && @filtros[nombre_campo.to_sym][:tipo].present?
        @filtros[nombre_campo.to_sym][:tipo]
      elsif @clase_modelo.respond_to?(:enumerized_attributes) && @clase_modelo.enumerized_attributes[nombre_campo.to_s].present?
        :enumerized
      elsif find_on_all_associations(@clase_modelo, campo).present?
        :asociacion
      else
        columna = @clase_modelo.columns.find { |c| c.name == nombre_campo.to_s }
        if columna.nil?
          return :date if campo.match(/fecha/)

          # Si el nombre del campo es 'discarded' entonces no es un campo
          # real sino filtro booleano por presencia de discarded_at
          return :boolean if campo.to_s == 'discarded'

          return
        end
        columna.type
      end
    end

    def comparador_array(sufijo)
      case sufijo
      when 'es_igual_a'
        '='
      else
        # si es 'incluye'
        # o si no tiene sufijo que por defecto se use el includes
        '@>'
      end
    end

    def comparador(campo)
      if campo.to_s.ends_with?('_desde')
        '>='
      elsif campo.to_s.ends_with?('_hasta')
        '<='
      else
        '='
      end
    end

    def extraer_sufijo(campo)
      SUFIJOS.each do |sufijo|
        return sufijo if campo.to_s.ends_with?("_#{sufijo}")
      end

      nil
    end

    def sin_sufijo(campo)
      ret = campo.to_s.dup

      SUFIJOS.each do |sufijo|
        ret.gsub!(/_#{sufijo}$/, '')
      end

      ret
    end

    def placeholder_campo(campo)
      suf = extraer_sufijo(campo)
      key = [controller_name, action_name, 'filter', sin_sufijo(campo)].join('.')
      dflt = :"activerecord.attributes.#{@clase_modelo.model_name.i18n_key}.#{sin_sufijo(campo)}"
      human_name = @clase_modelo.human_attribute_name(key, default: dflt)

      ret =
        if suf.present?
          "#{human_name} #{I18n.t(suf, scope: 'ransack.predicates')}"
        else
          human_name
        end

      ret.strip.downcase.tap { _1[0] = _1[0].capitalize }
    end

    def filtros_html(options = {})
      @form = options[:form]

      raise PgEngine::Error, 'se debe setear el form' if @form.blank?

      res = ''
      @filtros.each do |campo, opciones|
        if opciones[:oculto] ||
           (options[:except].present? && options[:except].include?(campo.to_sym)) ||
           (options[:only].present? && options[:only].exclude?(campo.to_sym))
          next
        end

        res += case tipo(campo)
               when :enumerized
                 filtro_select(campo, placeholder_campo(campo))
               when :asociacion
                 filtro_asociacion(campo, placeholder_campo(campo))
               when :date, :datetime
                 filtro_fecha(campo, placeholder_campo(campo))
               when :boolean
                 filtro_boolean(campo, placeholder_campo(campo))
               else
                 filtro_texto(campo, placeholder_campo(campo))
               end
      end

      if params[:q] && params[:q][:s]
        res += @form.hidden_field('s', value: params[:q][:s])
      end

      res.html_safe
    end

    def find_on_all_associations(klass, campo)
      nombre_campo = sin_sufijo(campo)
      klass.reflect_on_all_associations.find do |a|
        a.name == nombre_campo.to_sym || a.name == nombre_campo.sub(/_id$/, '').to_sym
      end
    end

    def obtener_asociacion(campo)
      asociacion = find_on_all_associations(@clase_modelo, campo)

      raise 'no se encontró la asociacion' if asociacion.nil?

      if asociacion.instance_of?(ActiveRecord::Reflection::ThroughReflection)
        through_class = asociacion.through_reflection.class_name.constantize
        asociacion_posta = find_on_all_associations(through_class, campo)

        raise 'no se encontró la asociacion' if asociacion_posta.nil?

        asociacion_posta
      else
        asociacion
      end
    end

    def filtro_asociacion(campo, placeholder = '')
      asociacion = obtener_asociacion(campo)
      nombre_clase = asociacion.options[:class_name]
      nombre_clase = asociacion.name.to_s.camelize if nombre_clase.nil?
      clase_asociacion = Object.const_get(nombre_clase)
      scope = Pundit.policy_scope!(Current.user, clase_asociacion)

      # Filtro soft deleted
      scope = scope.kept if scope.respond_to?(:kept)

      if @filtros[campo.to_sym][:scope_asociacion].present?
        scope = @filtros[campo.to_sym][:scope_asociacion].call(scope)
      end

      # TODO: default sort

      map = scope.map { |o| [o.to_s, o.id] }

      content_tag :div, class: 'col-auto' do
        content_tag :div, class: "filter #{active_class(campo)}" do
          suf = extraer_sufijo(campo)
          if suf.in? %w[in]
            @form.select campo, map, { multiple: true }, placeholder:, 'data-controller': 'selectize',
                                                         class: 'form-control form-control-sm pg-input-lg'
          else
            @form.select campo, map, { include_blank: "Seleccionar #{placeholder.downcase}" }, class: 'form-select form-select-sm pg-input-lg'
          end
        end
      end
    end

    def filtro_select(campo, placeholder = '')
      map = @clase_modelo.send(sin_sufijo(campo)).values.map do |key|
        [I18n.t("#{@clase_modelo.to_s.underscore}.#{campo}.#{key}", default: key.humanize),
         key.value]
      end
      content_tag :div, class: 'col-auto' do
        content_tag :div, class: "filter #{active_class(campo)}" do
          suf = extraer_sufijo(campo)
          if suf.in? %w[in]
            @form.select(campo, map, { multiple: true }, placeholder:, class: 'form-control form-control-sm pg-input-lg', 'data-controller': 'selectize')
          else
            @form.select(campo, map, { include_blank: "Seleccionar #{placeholder.downcase}" }, placeholder:, class: 'form-select form-select-sm pg-input-lg')
          end
        end
      end
    end

    def filtro_texto(campo, placeholder = '')
      content_tag :div, class: 'col-auto' do
        content_tag :div, class: "filter #{active_class(campo)}" do
          @form.search_field(
            campo, class: 'form-control form-control-sm allow-enter-submit', placeholder:, autocomplete: 'off'
          )
        end
      end
    end

    def filtro_boolean(campo, placeholder = '')
      map = [%w[Sí true], %w[No false]]

      include_blank = "¿#{placeholder.titleize}?"

      content_tag :div, class: 'col-auto' do
        content_tag :div, class: "filter #{active_class(campo)}" do
          @form.select campo.to_sym, map, { include_blank: }, class: 'form-select form-select-sm pg-input-lg'
        end
      end
    end

    def filtro_fecha(campo, placeholder = '')
      content_tag :div, class: 'col-auto' do
        content_tag :div, class: "filter #{active_class(campo)}" do
          label_tag(nil, placeholder, class: 'text-body-secondary') +
            @form.date_field(
              campo, class: 'form-control form-control-sm d-inline-block w-auto ms-1', placeholder:, autocomplete: 'off'
            )
        end
      end
    end

    def active_class(campo)
      if parametros_controller[:q] &&
         [parametros_controller[:q][campo.to_sym]].flatten.compact_blank.any?
        'active'
      else
        ''
      end
    end

    def parametros_controller
      params
    end
  end
end
