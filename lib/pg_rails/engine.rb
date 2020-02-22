module PgRails
  class Engine < ::Rails::Engine
    config.app_generators do |g|
      g.fixture_replacement :pg_factory_bot
    end
  end
end
