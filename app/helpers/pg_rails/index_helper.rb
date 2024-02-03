# frozen_string_literal: true

module PgRails
  module IndexHelper
    def encabezado(campo, options = {})
      clase = (options[:clase] || @clase_modelo)
      if options[:ordenable]
        field = controller.instance_variable_get(:"@field")
        direction = controller.instance_variable_get(:"@direction")
        uri = URI.parse(request.url)
        if uri.query.present?
          cgi = CGI.parse(uri.query)
        else
          cgi = {}
        end
        cgi["order_by"] = campo
        cgi["order_direction"] =
          if field.to_s == campo.to_s && direction.to_s == 'asc'
            'desc'
          else
            'asc'
          end

        if field.to_s == campo.to_s
          symbol =
            if direction.to_s == 'asc'
              '<i class="bi bi-sort-down-alt" />'
            elsif direction.to_s == 'desc'
              '<i class="bi bi-sort-up" />'
            end
        else
          symbol = ''
        end

        uri.query = cgi.map {|a,b| [a, (b.length == 1 ? b.first : b)]}.to_h.to_query

        link_to(clase.human_attribute_name(campo), uri.to_s) + " #{symbol}".html_safe
      else
        clase.human_attribute_name(campo)
      end
    end
  end
end
