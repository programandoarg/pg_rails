module PgRails
  class FiltrosBuilder
    include ActionView::Helpers
    include ActionView::Context
    include PostgresHelper
    attr_accessor :controller

    SUFIJOS = ['desde', 'hasta']

    def initialize(controller, clase_modelo, campos)
      @clase_modelo = clase_modelo
      @campos = campos
      @controller = controller
      @filtros = {}
      @campos.each { |campo| @filtros[campo] = {} }
    end

    def filtro_oculto(campo)
      @filtros[campo] = { oculto: true }
    end

    def filtrar(query)
      (@filtros).each do |campo, opciones|
        next unless params[campo].present?
        if tipo(campo).in?([:integer, :float, :decimal])
          query = query.where("#{@clase_modelo.table_name}.#{campo} = ?", params[campo])
        elsif tipo(campo) == :enumerized
          query = query.where("#{@clase_modelo.table_name}.#{campo} = ?", params[campo])
        elsif tipo(campo) == :asociacion
          asociacion = @clase_modelo.reflect_on_all_associations.find {|a| a.name == campo }
          if asociacion.class == ActiveRecord::Reflection::HasAndBelongsToManyReflection
            array = params[campo].class == Array ? params[campo].join(',') : params[campo]
            query = query.joins(campo).group("#{@clase_modelo.table_name}.id").having("ARRAY_AGG(#{asociacion.join_table}.#{asociacion.association_foreign_key}) @> ARRAY[#{array}]::bigint[]")
          else
            query = query.where("#{@clase_modelo.table_name}.#{campo}_id = ?", params[campo])
          end
        elsif tipo(campo) == :string
          query = query.where("#{@clase_modelo.table_name}.#{campo} ILIKE '%#{params[campo]}%'")
        elsif tipo(campo) == :date || tipo(campo) == :datetime
          begin
            fecha = Date.parse(params[campo])
            if tipo(campo) == :datetime && comparador(campo) == '<'
              fecha = fecha + 1.day - 1.second
            end
            campo_a_comparar = "#{@clase_modelo.table_name}.#{quitar_sufijo(campo)}"
            query = query.where("#{campo_a_comparar} #{comparador(campo)} ?", fecha)
          rescue ArgumentError
          end
        end
      end
      query
    end

    def tipo(campo)
      if @clase_modelo.respond_to?(:enumerized_attributes) && @clase_modelo.enumerized_attributes[campo.to_s].present?
        :enumerized
      elsif @clase_modelo.reflect_on_all_associations.find {|a| a.name == campo }.present?
        :asociacion
      else
        campo = quitar_sufijo(campo)
        columna = @clase_modelo.columns.find {|columna| columna.name == campo.to_s}
        if columna.nil?
          Logueador.warning("no existe el campo: #{campo}")
          return
        end
        columna.type
      end
    end

    def comparador(campo)
      if campo.to_s.ends_with?('_desde')
        '>'
      elsif campo.to_s.ends_with?('_hasta')
        '<'
      else
        '='
      end
    end

    def sufijo(campo)
      SUFIJOS.each do |sufijo|
        if campo.to_s.ends_with?("_" + sufijo)
          return sufijo
        end
      end
      nil
    end

    def quitar_sufijo(campo)
      ret = campo.to_s.dup
      SUFIJOS.each do |sufijo|
        ret.gsub!(/_#{sufijo}$/, '')
      end
      ret
    end

    def placeholder_campo(campo)
      suf = sufijo(campo)
      if suf.present?
        "#{@clase_modelo.human_attribute_name(quitar_sufijo(campo))} #{suf}"
      else
        @clase_modelo.human_attribute_name(campo)
      end
    end

    def filtros_html
      res = ''
      @filtros.each do |campo, opciones|
        next if opciones[:oculto]
        if tipo(campo) == :enumerized
          res += filtro_select(campo, placeholder_campo(campo))
        elsif tipo(campo) == :asociacion
          res += filtro_asociacion(campo, placeholder_campo(campo))
        elsif tipo(campo) == :date || tipo(campo) == :datetime
          res += filtro_fecha(campo, placeholder_campo(campo))
        else
          res += filtro_texto(campo, placeholder_campo(campo))
        end
      end
      res.html_safe
    end

    def filtro_asociacion(campo, placeholder = '')
      asociacion = @clase_modelo.reflect_on_all_associations.find {|a| a.name == campo }
      multiple = asociacion.class == ActiveRecord::Reflection::HasAndBelongsToManyReflection
      nombre_clase = asociacion.options[:class_name]
      if nombre_clase.nil?
        nombre_clase = asociacion.name.to_s.camelize
      end
      clase_asociacion = Object.const_get(nombre_clase)
      map = clase_asociacion.all.map { |o| [o.to_s, o.id] }

      map.unshift ["Seleccionar #{@clase_modelo.human_attribute_name(campo.to_sym).downcase}", nil]
      default = params[campo].nil? ? nil : params[campo]
      content_tag :div, class: 'filter' do
        if multiple
          select_tag campo, options_for_select(map, default), multiple: true, class: 'form-control selectize pg-input-lg'
        else
          select_tag campo, options_for_select(map, default), class: 'form-control chosen-select pg-input-lg'
        end
      end
    end

    def filtro_select(campo, placeholder = '')
      map = @clase_modelo.send(campo).values.map { |key| [key.humanize, key.value] }
      map.unshift ["-", nil]
      default = params[campo].nil? ? nil : params[campo]
      content_tag :div, class: 'filter' do
        select_tag campo, options_for_select(map, default), class: 'form-control pg-input-lg'
      end
    end

    def filtro_texto(campo, placeholder = '')
      content_tag :div, class: 'filter' do
        content_tag :div, class: 'input-group', style: 'width:230px' do
          text_field_tag(
            campo, params[campo], class: "form-control", placeholder: placeholder, autocomplete: "off"
          ) + content_tag(:span, class: 'input-group-btn', type: :submit) do
            button_tag class: 'btn btn-primary disabled' do
              content_tag :span, nil, class: 'fa fa-search'
            end
          end
        end
      end
    end

    def filtro_fecha(campo, placeholder = '')
      content_tag :div, class: 'filter' do
        content_tag :div, class: 'input-group', style: 'width:230px' do
          text_field_tag(
            campo, params[campo], class: "form-control datefield", placeholder: placeholder, autocomplete: "off"
          ) + content_tag(:span, class: 'input-group-btn', type: :submit) do
            button_tag class: 'btn btn-primary disabled' do
              content_tag :span, nil, class: 'fa fa-search'
            end
          end
        end
      end
    end
  end
end
