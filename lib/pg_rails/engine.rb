require 'pg_rails/utils/filtros_builder'
require 'pg_rails/simple_form/initializer'

module PgRails
  class Engine < ::Rails::Engine
    config.eager_load_paths += %W(#{config.root}/app/inputs)

    config.autoload_paths << File.expand_path("../app/inputs", __FILE__)

    initializer 'cosas', after: "factory_bot.set_fixture_replacement" do
      config.app_generators do |g|
        g.fixture_replacement :pg_factory_bot, dir: 'spec/factories'
        g.test_framework :rspec
      end
    end
  end
end
