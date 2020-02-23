require 'pg_rails/utils/filtros_builder'
require 'pg_rails/utils/logueador'
require 'pg_rails/simple_form/initializer'

module PgRails
  class Engine < ::Rails::Engine
    isolate_namespace PgRails

    initializer 'configurar_generators', after: "factory_bot.set_fixture_replacement" do
      config.app_generators do |g|
        g.fixture_replacement :pg_factory_bot, dir: 'spec/factories'
        g.test_framework :rspec
        g.orm :active_record
      end
    end

    if Rails.env.test?
      initializer 'configuracion_rspec' do
        require 'pg_rails/utils/configurador_rspec'
      end
    end
  end
end
