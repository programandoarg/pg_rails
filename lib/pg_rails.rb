require "pg_rails/engine"
require "pg_rails/configuracion"

module PgRails
  class << self
    attr_writer :configuracion

    def configuracion
      @configuracion ||= Configuracion.new
    end

    def configurar
      yield(configuracion)
    end
  end
end
