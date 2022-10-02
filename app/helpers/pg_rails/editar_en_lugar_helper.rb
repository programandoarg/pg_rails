# frozen_string_literal: true

module PgRails
  module EditarEnLugarHelper
    def editar_en_lugar(objeto, atributo, tipo = :input, url = nil, collection = nil)
      url = pg_rails.editar_en_lugar_path(objeto) if url.nil?
      if tipo == :checkbox
        best_in_place objeto, atributo, url: url, as: tipo, collection: %w[No Si],
                                        param: objeto.model_name.name
      elsif tipo == :date
        best_in_place objeto, atributo, url: url, as: tipo, display_with: lambda { |v|
                                                                            dmy(v)
                                                                          }, param: objeto.model_name.name
        # best_in_place objeto, atributo, url: editar_en_lugarurl(objeto), as: tipo, display_with: lambda { |v| dmy(v) }, class: 'datefield'
      elsif tipo == :textarea
        funcion = lambda do |valor|
          return unless valor.present?

          valor.gsub!("\r\n", '<br>')
          valor.gsub!("\n", '<br>')
          valor.html_safe
        end
        best_in_place objeto, atributo, url: url, as: tipo, display_with: funcion,
                                        param: objeto.model_name.name
      elsif tipo == :select && collection.present?
        best_in_place objeto, atributo, url: url, as: tipo, collection: collection,
                                        param: objeto.model_name.name, value: objeto.send(atributo), inner_class: 'form-control'
      else
        best_in_place objeto, atributo, url: url, as: tipo, param: objeto.model_name.name
      end
    end

    # Versión mejorada de editar_en_lugar, pero le pongo v2 por retrocompatibilidad
    # La diferencia es que recibe un hash "options" y se le pueden agregar cualquiera de las options
    # que admite best_in_place
    def editar_en_lugar_v2(objeto, atributo, tipo = :input, options = {})
      options[:url] = pg_rails.editar_en_lugar_path(objeto) if options[:url].nil?
      options[:as] = tipo
      options[:param] = objeto.model_name.name
      options[:inner_class] = 'form-control' if options[:inner_class].nil?
      options[:class] = 'editar_en_lugar_v2'
      options[:html_attrs] = { autocomplete: :off }
      # url = pg_rails.editar_en_lugar_path(objeto) if url.nil?
      if tipo == :checkbox
        options[:collection] = %w[No Si]

      elsif tipo == :date
        options[:display_with] = ->(v) { dmy(v) } if options[:display_with].nil?

      elsif tipo == :textarea
        funcion = lambda do |valor|
          return unless valor.present?

          valor.gsub!("\r\n", '<br>')
          valor.gsub!("\n", '<br>')
          valor.html_safe
        end
        options[:display_with] = funcion if options[:display_with].nil?

      elsif tipo == :select && options[:collection].present?
        options[:value] = objeto.send(atributo)
      end

      best_in_place objeto, atributo, options
    end

    def encabezado(campo, options = {})
      clase = (options[:clase] || @clase_modelo)
      if options[:ordenable]
        clase.human_attribute_name(campo)
      else
        clase.human_attribute_name(campo)
      end
    end

    # deprecado
    def ordenable(smart_listing, campo)
      smart_listing.sortable @clase_modelo.human_attribute_name(campo), campo
    end
  end
end
