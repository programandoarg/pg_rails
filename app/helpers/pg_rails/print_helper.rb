module PgRails
  module PrintHelper
    class FechaInvalidaError < StandardError
    end

    def mostrar_con_link(objeto, &block)
      if objeto.present?
        if policy(objeto).show?
          link_to truncate_title(block_given? ? yield : objeto), objeto
        else
          truncate_title(block_given? ? yield : objeto)
        end
      end
    end

    def truncate_title(input, length = 20)
      string = input.to_s
      if string.length > length
        content_tag :span, title: input, rel: :tooltip do
          truncate string, length: length
        end
      else
        string
      end
    end

    def print_cuit(cuit_number)
      return '' unless cuit_number.present?

      str = cuit_number.to_s
      "#{str[0..1]}-#{str[2..9]}-#{str[10]}"
    end

    def dmy_time(date)
      date = parsear_tiempo(date) if date.is_a? String
      return unless date.present?

      date.strftime('%d/%m/%Y %H:%M')
    end

    def dmy(date)
      date = parsear_fecha(date) if date.is_a? String
      return unless date.present?

      date.strftime('%d/%m/%Y')
    end

    def ymd(date)
      date = parsear_fecha(date) if date.is_a? String
      return unless date.present?

      date.strftime('%Y/%m/%d')
    end

    def dmyg(date)
      date = parsear_fecha(date) if date.is_a? String
      return unless date.present?

      date.strftime('%d-%m-%Y')
    end

    def ymdg(date)
      date = parsear_fecha(date) if date.is_a? String
      return unless date.present?

      date.strftime('%Y-%m-%d')
    end

    def myg(date)
      date = parsear_fecha(date) if date.is_a? String
      return unless date.present?

      date.strftime('%m-%Y')
    end

    def print_number(number)
      number_with_precision(number, delimiter: ',', separator: '.', precision: 2)
    end

    def print_number_coma(number)
      number_with_precision(number, delimiter: '.', separator: ',', precision: 2)
    end

    def print_boolean(boolean)
      return if boolean.nil?
      return 'Si' if boolean

      'No'
    end

    def print_currency(number, moneda = 'pesos')
      return unless number.present?

      "<span class='currency #{moneda}'>#{number_with_precision(number, delimiter: '.', separator: ',', precision: 2)}</span>".html_safe
    end

    def print_currency2(number, moneda = 'pesos')
      "#{simbolo_moneda(moneda)} #{number_with_precision(number, delimiter: '.', separator: ',', precision: 2)}"
    end

    def simbolo_moneda(moneda)
      return '$' if moneda == 'pesos'
      return 'U$S' if moneda == 'dolares'
      return '€' if moneda == 'euros'
      return 'R$' if moneda == 'reales'
      return 'CLP' if moneda == 'pesos_chilenos'
      return 'MXN' if moneda == 'pesos_mexicanos'

      '$'
    end

    def print_value(nombre_clase, field, value)
      if !!value == value # es booleano
        value ? 'Si' : 'No'
      elsif value.nil?
        '-'
      elsif field.ends_with?("_id") && value.present? && (asociacion = nombre_clase.constantize.reflect_on_all_associations.find {|a| a.name == field.gsub(/_id$/, '').to_sym })
        nombre_clase = asociacion.options[:class_name]
        multiple = asociacion.class.in?([
          ActiveRecord::Reflection::HasAndBelongsToManyReflection,
          ActiveRecord::Reflection::HasManyReflection
        ])
        if nombre_clase.nil?
          if multiple
            nombre_clase = asociacion.name.to_s.singularize.camelize
          else
            nombre_clase = asociacion.name.to_s.camelize
          end
        end
	begin
          clase_asociacion = Object.const_get(nombre_clase)
          clase_asociacion.find(value)
	rescue NameError => e
	  value
	end
      else
        begin
          if nombre_clase.constantize.defined_enums[field].present?
            valor = nombre_clase.constantize.defined_enums[field].invert[value]
            I18n.t("enums.#{nombre_clase.downcase}.#{field}.#{valor}", default: valor)
          elsif nombre_clase.constantize.respond_to?(:enumerized_attributes) && nombre_clase.constantize.enumerized_attributes[field.to_s].present?
            nombre_clase.constantize.new(field => value).send("#{field}_text")
          else
            truncate_title(value.to_s.encode("UTF-8", invalid: :replace, undef: :replace))
          end
        rescue NameError => e
          Rails.logger.error(e)
          Rollbar.error(e)
          truncate_title(value.to_s.encode("UTF-8", invalid: :replace, undef: :replace))
	  nil
        end
      end
    rescue StandardError => e
      Rails.logger.error(e)
      Rollbar.error(e)
      nil
    end

    def parsear_tiempo(datetime)
      return nil unless datetime.present?
      DateTime.parse(datetime)
    rescue ArgumentError
      raise FechaInvalidaError.new(datetime)
    end

    def parsear_fecha(date)
      return nil unless date.present?
      Date.parse(date)
    rescue ArgumentError
      raise FechaInvalidaError.new(date)
    end

    def show_percentage(value)
      return unless value.present?

      "#{value.round(2)} %"
    end
  end
end
