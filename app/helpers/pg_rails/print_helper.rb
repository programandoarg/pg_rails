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

    def print_value(value)
      value.nil? ? '<vacío>' : value
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
