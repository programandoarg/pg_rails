# frozen_string_literal: true

require 'pg_engine/engine'
require 'pg_engine/core_ext'
require 'pg_engine/configuracion'
require 'pg_engine/utils/logueador'

module PgRails
  class << self
    attr_writer :configuracion

    def configuracion
      @configuracion ||= Configuracion.new
    end

    def config
      configuracion
    end

    def configurar
      yield(configuracion)
    end
  end
end
