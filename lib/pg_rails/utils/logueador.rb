# frozen_string_literal: true

require 'rainbow'

module PgRails
  class Logueador
    class << self
      def excepcion(exception)
        titulo = Rainbow("  EXCEPCION #{exception.class} en #{caller.first}").red.bold
        detalles = Rainbow("  #{exception.message}").red
        Rails.logger.error("#{titulo}\n#{detalles}")
        Rollbar.error(exception)
      end

      def error(mensaje)
        titulo = Rainbow("  ERROR en #{caller.first}").red.bold
        detalles = Rainbow("  #{mensaje}").red
        Rails.logger.error("#{titulo}\n#{detalles}")
        Rollbar.error("#{mensaje}\n\n#{caller.join("\n")}")
      end

      def warning(mensaje)
        titulo = Rainbow("  WARNING en #{caller.first}").red.bold
        detalles = Rainbow("  #{mensaje}").red
        Rails.logger.warn("#{titulo}\n#{detalles}")
        Rollbar.warning("#{mensaje}\n\n#{caller.join("\n")}")
      end

      def info(mensaje)
        titulo = Rainbow("  INFO en #{caller.first}").blue.bold
        detalles = Rainbow("  #{mensaje}").blue
        Rails.logger.info("#{titulo}\n#{detalles}")
        Rollbar.info("#{mensaje}\n\n#{caller.join("\n")}")
      end
    end
  end
end
