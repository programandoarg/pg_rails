# frozen_string_literal: true

require 'rainbow'

module PgEngine
  module Utils
    class Logueador
      class << self
        def deprecated(mensaje)
          titulo = Rainbow("  WARNING en #{caller[1]}").yellow.bold
          detalles = Rainbow("  #{mensaje}").yellow
          Rails.logger.warn("#{titulo}\n#{detalles}")
          Rollbar.warning("#{mensaje}\n\n#{caller.join("\n")}")
        end

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
          titulo = Rainbow("  WARNING en #{caller.first}").yellow.bold
          detalles = Rainbow("  #{mensaje}").yellow
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
end
