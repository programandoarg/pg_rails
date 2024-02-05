module PgScaffold
  class Railtie < ::Rails::Railtie
    initializer 'configurar_generators', after: 'factory_bot.set_fixture_replacement' do
      require_relative 'monkey_patches/mejoras_de_atributos'
      require_relative 'monkey_patches/mejoras_a_named_base'

      config.app_generators do |g|
        g.test_framework :pg_rspec
        g.orm :pg_active_record

        g.fallbacks[:pg_rspec] = :rspec
        g.fallbacks[:pg_active_record] = :active_record
      end
    end
  end
end
