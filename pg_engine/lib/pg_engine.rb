# frozen_string_literal: true

require_relative 'pg_engine/engine'
require_relative 'pg_engine/core_ext'
require_relative 'pg_engine/configuracion'
require_relative 'pg_engine/utils/pg_logger'

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

    def resource_route(rails_router, key)
      rails_router.instance_eval do
        resources(key) do
          collection do
            get :abrir_modal
            post :buscar
          end
        end
      end
    end
  end
end
