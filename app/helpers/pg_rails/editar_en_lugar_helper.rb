module PgRails
  module EditarEnLugarHelper
    def editar_en_lugar(objeto, atributo, tipo = :input, _url = nil, collection = nil)
      _url = pg_rails.editar_en_lugar_path(objeto) if _url.nil?
      if tipo == :checkbox
        best_in_place objeto, atributo, url: _url, as: tipo, collection: ["No", "Si"], param: objeto.model_name.name
      elsif tipo == :date
        best_in_place objeto, atributo, url: _url, as: tipo, display_with: lambda { |v| dmy(v) }, param: objeto.model_name.name
        # best_in_place objeto, atributo, url: editar_en_lugar_url(objeto), as: tipo, display_with: lambda { |v| dmy(v) }, class: 'datefield'
      elsif tipo == :textarea
        funcion = lambda do |valor|
          return unless valor.present?
          valor.gsub!("\r\n", '<br>')
          valor.gsub!("\n", '<br>')
          valor.html_safe
        end
        best_in_place objeto, atributo, url: _url, as: tipo, display_with: funcion, param: objeto.model_name.name
      elsif tipo == :select && collection.present?
        best_in_place objeto, atributo, url: _url, as: tipo, collection: collection, param: objeto.model_name.name, value: objeto.send(atributo)
      else
        best_in_place objeto, atributo, url: _url, as: tipo, param: objeto.model_name.name
      end
    end

    def encabezado(smart_listing, campo, options = {})
      if options[:ordenable]
        smart_listing.sortable @clase_modelo.human_attribute_name(campo), campo
      else
        @clase_modelo.human_attribute_name(campo)
      end
    end

    # deprecado
    def ordenable(smart_listing, campo)
      smart_listing.sortable @clase_modelo.human_attribute_name(campo), campo
    end
  end
end
