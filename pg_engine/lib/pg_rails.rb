# frozen_string_literal: true

require 'pg_rails/engine'
require 'pg_rails/core_ext'
require 'pg_rails/configuracion'
require 'pg_rails/utils/logueador'
require 'pg_associable'
require 'pg_scaffold'
require 'pg_layout'

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
