# frozen_string_literal: true

module PgRails
  module PrintHelper
    class FechaInvalidaError < StandardError
    end

    # Genera un falso link que al clickear carga la url por ajax
    # Es igual a los links con remote: true, pero evita que abran el link en otra
    # pestaña. Movido de probella
    def pg_ajax_link(url, options = {})
      content_tag :span, class: 'pg_ajax_link', data: options.merge(url: url) do
        block_given? ? yield : ''
      end
    end

    def mostrar_con_link(objeto, options = {})
      if objeto.present?
        if policy(objeto).show?
          content = truncate_title(block_given? ? yield : objeto)
          if options[:new_tab]
            content += "&nbsp;<i class='fa fa-external-link'>".html_safe
            link_to content.html_safe, objeto, target: :_blank
          else
            link_to content.html_safe, objeto
          end
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

      "<span class='currency #{moneda}'>#{number_with_precision(number, delimiter: '.',
                                                                        separator: ',', precision: 2)}</span>".html_safe
    end

    def print_currency2(number, moneda = 'pesos')
      "#{simbolo_moneda(moneda)} #{number_with_precision(number, delimiter: '.', separator: ',',
                                                                 precision: 2)}"
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
      if !value.nil? == value # es booleano
        value ? 'Si' : 'No'
      elsif value.nil?
        '-'
      else
        begin
          if nombre_clase.constantize.defined_enums[field].present?
            valor = nombre_clase.constantize.defined_enums[field].invert[value]
            I18n.t("enums.#{nombre_clase.downcase}.#{field}.#{valor}", default: valor)
          else
            truncate_title(value.to_s.encode('UTF-8', invalid: :replace, undef: :replace))
          end
        rescue NameError
          truncate_title(value.to_s.encode('UTF-8', invalid: :replace, undef: :replace))
        end
      end
    end

    def parsear_tiempo(datetime)
      return nil unless datetime.present?

      DateTime.parse(datetime)
    rescue ArgumentError
      raise FechaInvalidaError, datetime
    end

    def parsear_fecha(date)
      return nil unless date.present?

      Date.parse(date)
    rescue ArgumentError
      raise FechaInvalidaError, date
    end

    def show_percentage(value)
      return unless value.present?

      "#{value.round(2)} %"
    end
  end
end
