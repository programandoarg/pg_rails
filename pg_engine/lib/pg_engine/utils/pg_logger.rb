# frozen_string_literal: true

require 'rainbow'

def pg_warn(obj, type = :error)
  PgEngine::PgLogger.warn(obj, type)
end

module PgEngine
  class PgLogger
    class << self
      # DEPRECATED
      # Muestro el caller[1] para saber dónde se llamó a la función deprecada
      # def deprecated(mensaje)
      #   titulo = Rainbow("  WARNING en #{caller[1]}").yellow.bold
      #   detalles = Rainbow("  #{mensaje}").yellow
      #   Rails.logger.warn("#{titulo}\n#{detalles}")
      #   Rollbar.warning("#{mensaje}\n\n#{caller.join("\n")}")
      # end

      def warn(obj, type = :error)
        mensaje = if obj.is_a? Exception
                    obj.full_message.lines.first
                  else
                    obj
                  end
        notify(mensaje, type)
      end

      private

      def notify(mensaje, type)
        Rails.logger.send(type, titulo(mensaje, type))
        Rails.logger.send(type, detalles(type))
        Rollbar.send(type, "#{mensaje}\n\n#{bktrc.join("\n")}")
        nil
      end

      def titulo(mensaje, type)
        Rainbow(mensaje).bold.send(color_for(type))
      end

      def detalles(type)
        Rainbow("#{type.to_s.upcase} logueado en #{bktrc[0]}").send(color_for(type))
      end

      def bktrc
        bc = ActiveSupport::BacktraceCleaner.new
        bc.add_filter   { |line| line.gsub(%r{.*pg_rails/}, '') }
        bc.add_silencer { |line| /pg_logger/.match?(line) }
        bc.clean(caller)
      end

      def color_for(type)
        case type
        when :info
          :blue
        when :warn
          :yellow
        else # :error
          :red
        end
      end
    end
  end
end
