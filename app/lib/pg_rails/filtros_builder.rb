module PgRails
  class FiltrosBuilder
    # include ActionView::Helpers
    # include PostgresHelper

    SUFIJOS = ['desde', 'hasta', 'incluye', 'es_igual_a']

    def initialize(*args)
      if args.count == 3
        opciones = {}
        opciones[:controller] = args[0]
        opciones[:clase_modelo] = args[1]
        opciones[:filtros_permitidos] = args[2]
        puts "DEPRECADO, WACH. el constructor de 3 parámetros de FiltrosBuilder ya no va más. #{caller.first}"
      elsif args.count == 1
        opciones = args.first
      else
        fail 'cantidad de argumentos incorrecta'
      end
      opciones_generales(opciones)
    end

    def opciones_generales(opciones = {})
      @opciones = opciones
      controller = opciones[:controller]

      @clase_modelo = opciones[:clase_modelo] if opciones[:clase_modelo].present?
      # saco la clase modelo del controller si hace falta
      @clase_modelo = controller.clase_modelo if @clase_modelo.nil? && controller.present?
      @scope = opciones[:scope] if opciones[:scope].present?

      @user = opciones[:user]
      if @user.nil? && controller.present?
        @user = controller.current_user
      end


      # seteo la scope a partir del modelo y viceversa
      @clase_modelo = @scope.model if @clase_modelo.nil? && @scope.present?
      if @scope.nil? && @clase_modelo.present?
        if @user.present?
          @scope = Pundit.policy_scope!(@user, @clase_modelo)
        else
          @scope = @clase_modelo.all
        end
      end

      @params = opciones[:params] if opciones[:params].present?

      if @params.nil? && controller.present?
        @params = controller.params
      else
        @params = {}
      end

      @filtros = {} if @filtros.nil?

      if opciones[:filtrar_por].present?
        opciones[:filtrar_por].keys.each { |filtro| @filtros[filtro] = {} }
        @params = opciones[:filtrar_por]
      end

      if opciones[:filtros_permitidos]
        opciones[:filtros_permitidos].each { |filtro| @filtros[filtro] = {} }
      end
    end

    def opciones(campo, opciones)
      if @filtros[campo].present?
        @filtros[campo].merge! opciones
      else
        @filtros[campo] = opciones
      end
    end

    # querys customizadas por campo
    def query(campo, &block)
      puts "DEPRECADO, WACH. usá el método 'opciones'. #{caller.first}"
      @filtros[campo] = {} if @filtros[campo].nil?
      @filtros[campo][:query] = block
    end

    def algun_filtro_presente?
      @filtros.keys.any? { |campo| @params[campo].present? }
    end

    def filtrar(*args)
      if args.count == 2
        query = args[0]
        @params = args[1]
        puts "DEPRECADO, WACH. FiltrosBuilder#filtrar ya no recibe argumentos. #{caller.first}"
      elsif args.count == 1
        query = args[0]
        puts "DEPRECADO, WACH. FiltrosBuilder#filtrar ya no recibe argumentos. #{caller.first}"
      else
        query = @scope
      end

      unless !query.respond_to?(:without_deleted) || @opciones[:with_deleted]
        query = query.without_deleted
      end

      @filtros.each do |campo, opciones|
        next unless @params[campo].present?
        if @filtros[campo.to_sym].present? && @filtros[campo.to_sym][:query].present?
          query = @filtros[campo.to_sym][:query].call(query, @params[campo])
        elsif tipo(campo).in?([:integer, :float, :decimal])
          query = query.where("#{@clase_modelo.table_name}.#{campo} = ?", @params[campo])
        elsif tipo(campo) == :enumerized
          query = query.where("#{@clase_modelo.table_name}.#{campo} = ?", @params[campo])
        elsif tipo(campo) == :asociacion
          nombre_campo = sin_sufijo(campo)
          suf = extraer_sufijo(campo)
          asociacion = obtener_asociacion(nombre_campo)
          if asociacion.class == ActiveRecord::Reflection::HasAndBelongsToManyReflection
            array = @params[campo].class == Array ? @params[campo].join(',') : @params[campo]
            query = query.joins(nombre_campo.to_sym).group("#{@clase_modelo.table_name}.id")
              .having("ARRAY_AGG(#{asociacion.join_table}.#{asociacion.association_foreign_key}) #{comparador_array(suf)} ARRAY[#{array}]::bigint[]")
          elsif asociacion.class == ActiveRecord::Reflection::BelongsToReflection
            query = query.where("#{@clase_modelo.table_name}.#{campo}_id = ?", @params[campo])
          else
            fail 'filtro de asociacion no soportado'
          end
        elsif tipo(campo).in?([:string, :text])
          match_vector = @params[campo].split.map {|a| a + ':*'}.join(' & ')
          match_like = "%#{@params[campo]}%"
          condicion = "to_tsvector(coalesce(unaccent(#{campo}), '')) @@ to_tsquery( unaccent(?) )"
          condicion += " OR unaccent(CONCAT(#{campo})) ILIKE unaccent(?)"
          query = query.where(condicion, "#{I18n.transliterate(match_vector)}", "#{I18n.transliterate(match_like)}")
        elsif tipo(campo) == :date || tipo(campo) == :datetime
          begin
            fecha = Date.parse(@params[campo])
            if tipo(campo) == :datetime && comparador(campo) == '<'
              fecha = fecha + 1.day - 1.second
            end
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
      elsif @clase_modelo.reflect_on_all_associations.find {|a| a.name == nombre_campo.to_sym }.present?
        :asociacion
      else
        columna = @clase_modelo.columns.find {|columna| columna.name == nombre_campo.to_s}
        if columna.nil?
          Rails.logger.warn("no existe el campo: #{nombre_campo}")
          return
        end
        columna.type
      end
    end

    def comparador_array(sufijo)
      if sufijo == 'es_igual_a'
        '='
      elsif sufijo == 'incluye'
        '@>'
      else
        # si no tiene sufijo que por defecto se use el includes
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
        if campo.to_s.ends_with?("_" + sufijo)
          return sufijo
        end
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

        if tipo(campo) == :enumerized
          res += filtro_select(campo, placeholder_campo(campo))
        elsif tipo(campo) == :asociacion
          res += filtro_asociacion(campo, placeholder_campo(campo))
        elsif tipo(campo) == :date || tipo(campo) == :datetime
          res += filtro_fecha(campo, placeholder_campo(campo))
        elsif tipo(campo) == :boolean
          res += filtro_checkbox(campo)
        else
          res += filtro_texto(campo, placeholder_campo(campo))
        end
      end
      res.html_safe
    end

    def obtener_asociacion(campo)
      nombre_campo = sin_sufijo(campo)
      suf = extraer_sufijo(campo)
      asociacion = @clase_modelo.reflect_on_all_associations.find {|a| a.name == nombre_campo.to_sym }
      fail 'no se encontró la asociacion' if asociacion.nil?
      if asociacion.class == ActiveRecord::Reflection::ThroughReflection
        through_class = asociacion.through_reflection.class_name.constantize
        asociacion_posta = through_class.reflect_on_all_associations.find {|a| a.name == nombre_campo.to_sym }
        fail 'no se encontró la asociacion' if asociacion_posta.nil?
        asociacion_posta
      else
        asociacion
      end
    end

    def filtro_asociacion(campo, placeholder = '')
      asociacion = obtener_asociacion(campo)
      multiple = asociacion.class == ActiveRecord::Reflection::HasAndBelongsToManyReflection
      nombre_clase = asociacion.options[:class_name]
      if nombre_clase.nil?
        nombre_clase = asociacion.name.to_s.camelize
      end
      clase_asociacion = Object.const_get(nombre_clase)
      scope = Pundit.policy_scope!(@user, clase_asociacion)
      if scope.respond_to?(:without_deleted)
        scope = scope.without_deleted
      end
      map = scope.map { |o| [o.to_s, o.id] }

      unless @filtros[campo.to_sym].present? && @filtros[campo.to_sym][:include_blank] == false
        map.unshift ["Seleccionar #{@clase_modelo.human_attribute_name(campo.to_sym).downcase}", nil]
      end

      default = @params[campo].nil? ? nil : @params[campo]
      content_tag :div, class: 'filter' do
        if multiple
          select_tag campo, options_for_select(map, default), multiple: true, class: 'form-control selectize pg-input-lg'
        else
          select_tag campo, options_for_select(map, default), class: 'form-control chosen-select pg-input-lg'
        end
      end
    end

    def filtro_select(campo, placeholder = '')
      map = @clase_modelo.send(campo).values.map do |key|
        [I18n.t("#{@clase_modelo.to_s.underscore}.#{campo}.#{key}", default: key.humanize), key.value]
      end
      unless @filtros[campo.to_sym].present? && @filtros[campo.to_sym][:include_blank] == false
        map.unshift ["Seleccionar #{placeholder.downcase}", nil]
      end
      default = @params[campo].nil? ? nil : @params[campo]
      content_tag :div, class: 'filter' do
        select_tag campo, options_for_select(map, default), class: 'form-control pg-input-lg'
      end
    end

    def filtro_texto(campo, placeholder = '')
      content_tag :div, class: 'filter' do
        content_tag :div, class: 'input-group', style: 'width:230px' do
          text_field_tag(
            campo, @params[campo], class: "form-control", placeholder: placeholder, autocomplete: "off"
          ) + content_tag(:div, class: 'input-group-append input-group-btn') do
            button_tag class: 'btn btn-outline-secondary disabled', type: :button do
              content_tag :span, nil, class: 'fa fa-search'
            end
          end
        end
      end
    end
    def filtro_checkbox(campo)
      content_tag :div, class: 'filter' do
        content_tag :div, class: 'input-group', style: 'width:230px' do
          check_box_tag(
            campo, @params[campo], false, class: "form-control"
          )
        end
      end
    end

    def filtro_fecha(campo, placeholder = '')
      content_tag :div, class: 'filter' do
        content_tag :div, class: 'input-group', style: 'width:230px' do
          text_field_tag(
            campo, @params[campo], class: "form-control datefield", placeholder: placeholder, autocomplete: "off"
          ) + content_tag(:div, class: 'input-group-append input-group-btn') do
            button_tag class: 'btn btn-outline-secondary disabled', type: :button do
              content_tag :span, nil, class: 'fa fa-search'
            end
          end
        end
      end
    end
  end
end
