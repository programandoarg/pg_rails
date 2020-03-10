<%= clase_aplicacion %>.configure do
  config.generators do |g|
    g.fixture_replacement :pg_factory_bot, dir: 'spec/factories'
    g.test_framework :pg_rspec
    g.orm :pg_active_record

    g.fallbacks[:pg_rspec] = :rspec
    g.fallbacks[:pg_active_record] = :active_record
  end
end
