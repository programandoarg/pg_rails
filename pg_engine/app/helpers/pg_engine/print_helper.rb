# frozen_string_literal: true

module PgEngine
  module PrintHelper
    include ActionView::Helpers::NumberHelper

    class FechaInvalidaError < PgEngine::Error
    end

    def mostrar_con_link(objeto, options = {})
      return if objeto.blank?

      if policy(objeto).show?
        content = truncate_title(block_given? ? yield : objeto)
        if options[:new_tab]
          content += "&nbsp;<i class='fa fa-external-link'>".html_safe
          link_to content.html_safe, objeto, target: :_blank, rel: :noopener
        else
          link_to content.html_safe, objeto
        end
      else
        truncate_title(block_given? ? yield : objeto)
      end
    end

    def truncate_title(input, length = 20)
      string = input.to_s
      if string.length > length
        content_tag :span, title: input, rel: :tooltip do
          truncate string, length:
        end
      else
        string
      end
    end

    def print_cuit(cuit_number)
      return '' if cuit_number.blank?

      str = cuit_number.to_s
      "#{str[0..1]}-#{str[2..9]}-#{str[10]}"
    end

    def dmy_time(date)
      date = parsear_tiempo(date) if date.is_a? String
      return if date.blank?

      date.strftime('%d/%m/%Y %H:%M')
    end

    def dmy(date)
      date = parsear_fecha(date) if date.is_a? String
      return if date.blank?

      date.strftime('%d/%m/%Y')
    end

    def ymd(date)
      date = parsear_fecha(date) if date.is_a? String
      return if date.blank?

      date.strftime('%Y/%m/%d')
    end

    def dmyg(date)
      date = parsear_fecha(date) if date.is_a? String
      return if date.blank?

      date.strftime('%d-%m-%Y')
    end

    def ymdg(date)
      date = parsear_fecha(date) if date.is_a? String
      return if date.blank?

      date.strftime('%Y-%m-%d')
    end

    def myg(date)
      date = parsear_fecha(date) if date.is_a? String
      return if date.blank?

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

    def print_currency(number, simbolo: '$', precision: nil)
      return if number.blank?

      # FIXME: testear
      precision ||= if (number % 0.01).positive?
                      3
                    else
                      (number % 1).positive? ? 2 : 0
                    end

      "#{simbolo} #{number_with_precision(number, delimiter: '.', separator: ',',
                                                  precision:)}"
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
      return nil if datetime.blank?

      DateTime.parse(datetime)
    rescue ArgumentError
      raise FechaInvalidaError, datetime
    end

    def parsear_fecha(date)
      return nil if date.blank?

      Date.parse(date)
    rescue ArgumentError
      raise FechaInvalidaError, date
    end

    def show_percentage(value)
      return if value.blank?

      "#{value.round(2)} %"
    end
  end
end
