# frozen_string_literal: true

module PgEngine
  module IndexHelper
    def encabezado(campo, options = {})
      campo = campo.to_s.sub(/_f\z/, '')
      campo = campo.to_s.sub(/_text\z/, '')
      clase = options[:clase] || @clase_modelo
      if options[:ordenable]
        field = controller.instance_variable_get(:@field)
        direction = controller.instance_variable_get(:@direction)
        uri = URI.parse(request.url)
        cgi = if uri.query.present?
                CGI.parse(uri.query)
              else
                {}
              end
        cgi['order_by'] = campo
        cgi['order_direction'] =
          if field.to_s == campo.to_s && direction.to_s == 'asc'
            'desc'
          else
            'asc'
          end

        symbol = if field.to_s == campo.to_s
                   if direction.to_s == 'asc'
                     '<i class="bi bi-sort-down-alt" />'
                   elsif direction.to_s == 'desc'
                     '<i class="bi bi-sort-up" />'
                   end
                 else
                   ''
                 end

        uri.query = cgi.transform_values { |b| (b.length == 1 ? b.first : b) }.to_query

        link_to(clase.human_attribute_name(campo), uri.to_s) + " #{symbol}".html_safe
      else
        clase.human_attribute_name(campo)
      end
    end
  end
end
