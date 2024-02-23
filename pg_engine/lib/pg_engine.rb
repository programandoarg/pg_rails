# frozen_string_literal: true

require_relative 'pg_engine/engine'
require_relative 'pg_engine/core_ext'
require_relative 'pg_engine/configuracion'
require_relative 'pg_engine/route_helpers'
require_relative 'pg_engine/utils/pg_logger'

require_relative '../app/helpers/pg_engine/print_helper'

module PgEngine
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
