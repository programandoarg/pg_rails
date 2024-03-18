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

      def color_for(type)
        case type
        when :error
          :red
        when :info
          :blue
        when :warn
          :yellow
        else
          :red
        end
      end

      def warn(obj, type = :error)
        if obj.is_a? Exception
          mensaje = obj.full_message.lines.first
        else
          mensaje = obj
        end
        # bktrc = ActiveSupport::BacktraceCleaner.new.clean(caller)
        bktrc = caller
        titulo = Rainbow(mensaje).bold.send(color_for(type))
        detalles = Rainbow("#{type.to_s.upcase} logueado en #{bktrc[1]}").send(color_for(type))
        Rails.logger.send(type, titulo)
        Rails.logger.send(type, detalles)
        Rollbar.send(type, "#{mensaje}\n\n#{bktrc.join("\n")}")
      end
    end
  end
end
