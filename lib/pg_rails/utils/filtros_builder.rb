module PgRails
  class FiltrosBuilder
    include ActionView::Helpers
    include ActionView::Context
    attr_accessor :controller

    def initialize(controller, clase_modelo, campos)
      @clase_modelo = clase_modelo
      @campos = campos
      @controller = controller
    end

    def filtrar(query)
      @campos.each do |campo|
        next unless params[campo].present?
        if tipo(campo).in?([:integer, :float, :decimal])
          query = query.where("#{campo} = ?", params[campo])
        elsif tipo(campo) == :enumerized
          query = query.where("#{campo} = ?", params[campo])
        elsif tipo(campo) == :asociacion
          query = query.where("#{campo}_id = ?", params[campo])
        elsif tipo(campo) == :string
          query = query.where("#{campo} ILIKE '%#{params[campo]}%'")
        elsif tipo(campo) == :date
          begin
            fecha = Date.parse(params[campo])
            query = query.where("#{quitar_sufijo(campo)} #{comparador(campo)} ?", fecha)
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

    def quitar_sufijo(campo)
      ret = campo.to_s.dup
      sufijos = ['_desde', '_hasta']
      sufijos.each do |sufijo|
        ret.gsub!(/#{sufijo}$/, '')
      end
      ret
    end

    def filtros_html
      res = ''
      @campos.each do |campo|
        if tipo(campo) == :enumerized
          res += filtro_select(campo, campo.to_s.humanize)
        elsif tipo(campo) == :asociacion
          res += filtro_asociacion(campo, campo.to_s.humanize)
        elsif tipo(campo) == :date
          res += filtro_fecha(campo, campo.to_s.humanize)
        else
          res += filtro_texto(campo, campo.to_s.humanize)
        end
      end
      res.html_safe
    end

    def filtro_asociacion(campo, placeholder = '')
      asociacion = @clase_modelo.reflect_on_all_associations.find {|a| a.name == campo }
      clase_asociacion = Object.const_get(asociacion.options[:class_name])
      map = clase_asociacion.all.map { |o| [o.to_s, o.id] }
      map.unshift ["-", nil]
      default = params[campo].nil? ? nil : params[campo]
      content_tag :div, class: 'filter' do
        select_tag campo, options_for_select(map, default), class: 'form-control pg-input-lg'
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
