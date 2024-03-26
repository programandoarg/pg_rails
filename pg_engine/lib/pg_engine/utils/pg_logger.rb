# frozen_string_literal: true

require 'rainbow'

# TODO: poder pasar blocks

def pg_err(obj)
  PgEngine::PgLogger.error(obj)
end

def pg_warn(obj, type = :error)
  PgEngine::PgLogger.warn(obj, type)
end

def pg_log(obj, type = :debug)
  PgEngine::PgLogger.warn("#{obj.inspect} (#{obj.class})", type)
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

      def error(obj)
        # Si es dev o test lanzo el error y si no, lo logueo para que no le salte al usuario
        raise obj if Rails.env.local?

        mensaje = if obj.is_a?(Exception) && obj.backtrace.present?
                    "#{obj.message}\nBacktrace:\n#{cleaner.clean(obj.backtrace).join("\n")}"
                  else
                    obj
                  end
        notify(mensaje, :error)
      end

      def warn(obj, type = :error)
        mensaje = if obj.is_a?(Exception) && obj.backtrace.present?
                    "#{obj.message}\nBacktrace:\n#{cleaner.clean(obj.backtrace).join("\n")}"
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
        Rainbow("#{type.to_s.upcase}: #{mensaje}").bold.send(color_for(type))
      end

      def detalles(type)
        Rainbow("  called in #{bktrc[0]}").send(color_for(type))
      end

      def cleaner
        bc = ActiveSupport::BacktraceCleaner.new
        bc.add_filter   { |line| line.gsub(%r{.*pg_rails/}, '') }
        bc.add_silencer { |line| /pg_logger/.match?(line) }
        bc
      end

      def bktrc
        cleaner.clean(caller)
      end

      def color_for(type)
        case type
        when :info
          :blue
        when :warn
          :yellow
        when :debug
          :orange
        else # :error
          :red
        end
      end
    end
  end
end
