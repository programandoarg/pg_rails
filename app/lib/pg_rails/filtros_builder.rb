# frozen_string_literal: true

module PgRails
  class FiltrosBuilder
    include ActionView::Helpers
    include ActionView::Context
    include PostgresHelper
    attr_accessor :controller

    SUFIJOS = %w[desde hasta incluye es_igual_a].freeze

    def initialize(controller, clase_modelo, campos)
      @clase_modelo = clase_modelo
      @campos = campos
      @controller = controller
      @filtros = {}
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

    def algun_filtro_presente?
      @campos.any? { |campo| parametros_controller[campo].present? }
    end

    def filtrar(query, parametros = nil)
      parametros = parametros_controller if parametros.nil?

      # Filtro soft deleted, y sea con paranoia o con discard
      query = query.without_deleted if query.respond_to?(:without_deleted)
      query = query.kept if query.respond_to?(:kept)

      @filtros.each do |campo, _opciones|
        next unless parametros[campo].present?

        if @filtros[campo.to_sym].present? && @filtros[campo.to_sym][:query].present?
          query = @filtros[campo.to_sym][:query].call(query, parametros[campo])
        elsif tipo(campo) == :enumerized
          query = query.where("#{@clase_modelo.table_name}.#{campo} = ?", parametros[campo])
        elsif tipo(campo).in?(%i[integer float decimal])
          campo_a_comparar = "#{@clase_modelo.table_name}.#{sin_sufijo(campo)}"
          query = query.where("#{campo_a_comparar} #{comparador(campo)} ?", parametros[campo])
        elsif tipo(campo) == :asociacion
          nombre_campo = sin_sufijo(campo)
          suf = extraer_sufijo(campo)
          asociacion = obtener_asociacion(nombre_campo)
          if asociacion.instance_of?(ActiveRecord::Reflection::HasAndBelongsToManyReflection)
            array = parametros[campo].instance_of?(Array) ? parametros[campo].join(',') : parametros[campo]
            query = query.joins(nombre_campo.to_sym).group("#{@clase_modelo.table_name}.id")
                         .having("ARRAY_AGG(#{asociacion.join_table}.#{asociacion.association_foreign_key}) #{comparador_array(suf)} ARRAY[#{array}]::bigint[]")
          elsif asociacion.instance_of?(ActiveRecord::Reflection::BelongsToReflection)
            query = query.where("#{@clase_modelo.table_name}.#{campo}_id = ?", parametros[campo])
          else
            raise 'filtro de asociacion no soportado'
          end
        elsif tipo(campo).in?(%i[string text])
          match_vector = parametros[campo].split.map { |a| "#{a}:*" }.join(' & ')
          match_like = "%#{parametros[campo]}%"
          campo_tabla = "#{@clase_modelo.table_name}.#{campo}"
          condicion = "to_tsvector(coalesce(unaccent(#{campo_tabla}), '')) @@ to_tsquery( unaccent(?) )"
          condicion += " OR unaccent(CONCAT(#{campo_tabla})) ILIKE unaccent(?)"
          query = query.where(condicion, I18n.transliterate(match_vector).to_s,
                              I18n.transliterate(match_like).to_s)
        elsif tipo(campo) == :boolean
          if campo.to_s == 'discarded'
            # Si el nombre del campo es 'discarded' entonces no es un campo
            # real sino filtro booleano por presencia de discarded_at
            case parametros[campo]
            when 'si'
              query = query.unscope(where: :discarded_at).where("#{@clase_modelo.table_name}.discarded_at IS NOT NULL")
            when 'no'
              query = query.unscope(where: :discarded_at).where("#{@clase_modelo.table_name}.discarded_at IS NULL")
            end
          else
            # Si no simplemente hago la query por booleano
            query = query.where("#{@clase_modelo.table_name}.#{campo} = ?", parametros[campo] == 'si')
          end
        elsif tipo(campo) == :date || tipo(campo) == :datetime
          begin
            fecha = Date.parse(parametros[campo])
            fecha = fecha + 1.day - 1.second if tipo(campo) == :datetime && comparador(campo) == '<'
            campo_a_comparar = "#{@clase_modelo.table_name}.#{sin_sufijo(campo)}"
            query = query.where("#{campo_a_comparar} #{comparador(campo)} ?", fecha)
          rescue ArgumentError
          end
        end
      end
      query
    end

    def tipo(campo)
      nombre_campo = sin_sufijo(campo)
      if @filtros[nombre_campo.to_sym].present? && @filtros[nombre_campo.to_sym][:tipo].present?
        @filtros[nombre_campo.to_sym][:tipo]
      elsif @clase_modelo.respond_to?(:enumerized_attributes) && @clase_modelo.enumerized_attributes[nombre_campo.to_s].present?
        :enumerized
      elsif @clase_modelo.reflect_on_all_associations.find do |a|
              a.name == nombre_campo.to_sym
            end.present?
        :asociacion
      else
        columna = @clase_modelo.columns.find { |c| c.name == nombre_campo.to_s }
        if columna.nil?
          return :date if campo.match(/fecha/)

          # Si el nombre del campo es 'discarded' entonces no es un campo
          # real sino filtro booleano por presencia de discarded_at
          return :boolean if campo.to_s == 'discarded'

          Rails.logger.warn("no existe el campo: #{nombre_campo}")
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
      if suf.present?
        "#{@clase_modelo.human_attribute_name(sin_sufijo(campo))} #{suf}"
      else
        @clase_modelo.human_attribute_name(campo)
      end
    end

    def filtros_html(options = {})
      res = ''
      @filtros.each do |campo, opciones|
        if opciones[:oculto] ||
           (options[:except].present? && options[:except].include?(campo.to_sym)) ||
           (options[:only].present? && !options[:only].include?(campo.to_sym))
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
      res.html_safe
    end

    def obtener_asociacion(campo)
      nombre_campo = sin_sufijo(campo)
      extraer_sufijo(campo)
      asociacion = @clase_modelo.reflect_on_all_associations.find do |a|
        a.name == nombre_campo.to_sym
      end
      raise 'no se encontró la asociacion' if asociacion.nil?

      if asociacion.instance_of?(ActiveRecord::Reflection::ThroughReflection)
        through_class = asociacion.through_reflection.class_name.constantize
        asociacion_posta = through_class.reflect_on_all_associations.find do |a|
          a.name == nombre_campo.to_sym
        end
        raise 'no se encontró la asociacion' if asociacion_posta.nil?

        asociacion_posta
      else
        asociacion
      end
    end

    def filtro_asociacion(campo, _placeholder = '')
      asociacion = obtener_asociacion(campo)
      multiple = asociacion.instance_of?(ActiveRecord::Reflection::HasAndBelongsToManyReflection)
      nombre_clase = asociacion.options[:class_name]
      nombre_clase = asociacion.name.to_s.camelize if nombre_clase.nil?
      clase_asociacion = Object.const_get(nombre_clase)
      scope = Pundit.policy_scope!(controller.current_usuario, clase_asociacion)

      # Filtro soft deleted, y sea con paranoia o con discard
      scope = scope.without_deleted if scope.respond_to?(:without_deleted)
      scope = scope.kept if scope.respond_to?(:kept)

      if @filtros[campo.to_sym][:scope_asociacion].present?
        scope = @filtros[campo.to_sym][:scope_asociacion].call(scope)
      end

      map = scope.map { |o| [o.to_s, o.id] }

      unless @filtros[campo.to_sym].present? && @filtros[campo.to_sym][:include_blank] == false
        map.unshift ["Seleccionar #{@clase_modelo.human_attribute_name(campo.to_sym).downcase}",
                     nil]
      end

      default = parametros_controller[campo].nil? ? nil : parametros_controller[campo]
      content_tag :div, class: 'filter' do
        if multiple
          select_tag campo, options_for_select(map, default), multiple: true,
                                                              class: 'form-select selectize pg-input-lg'
        else
          select_tag campo, options_for_select(map, default),
                     class: 'form-select chosen-select pg-input-lg'
        end
      end
    end

    def filtro_select(campo, placeholder = '')
      map = @clase_modelo.send(campo).values.map do |key|
        [I18n.t("#{@clase_modelo.to_s.underscore}.#{campo}.#{key}", default: key.humanize),
         key.value]
      end
      unless @filtros[campo.to_sym].present? && @filtros[campo.to_sym][:include_blank] == false
        map.unshift ["Seleccionar #{placeholder.downcase}",
                     nil]
      end
      default = parametros_controller[campo].nil? ? nil : parametros_controller[campo]
      content_tag :div, class: 'filter' do
        select_tag campo, options_for_select(map, default), class: 'form-select pg-input-lg'
      end
    end

    def filtro_texto(campo, placeholder = '')
      content_tag :div, class: 'filter' do
        text_field_tag(
          campo, parametros_controller[campo], class: 'form-control allow-enter-submit', placeholder: placeholder, autocomplete: 'off'
        )
      end
    end

    def filtro_boolean(campo, placeholder = '')
      map = [%w[Si si], %w[No no]]
      unless @filtros[campo.to_sym].present? && @filtros[campo.to_sym][:include_blank] == false
        map.unshift ["¿#{placeholder.titleize}?",
                     nil]
      end
      default = parametros_controller[campo].nil? ? nil : parametros_controller[campo]
      content_tag :div, class: 'filter' do
        select_tag campo, options_for_select(map, default), class: 'form-select pg-input-lg'
      end
    end

    def filtro_fecha(campo, placeholder = '')
      content_tag :div, class: 'filter' do
        text_field_tag(
          campo, parametros_controller[campo], class: 'form-control datefield', placeholder: placeholder, autocomplete: 'off'
        )
      end
    end

    def parametros_controller
      params
    end
  end
end
