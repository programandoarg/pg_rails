# frozen_string_literal: true

module PgEngine
  class Engine < ::Rails::Engine
    config.i18n.default_locale = :es
    config.time_zone = 'America/Argentina/Buenos_Aires'

    config.generators do |g|
      g.test_framework :pg_rspec
      g.orm :pg_active_record

      g.fallbacks[:pg_rspec] = :rspec
      g.fallbacks[:pg_active_record] = :active_record
    end

    initializer 'pg_engine.set_exceptions_app' do
      Rails.application.config.exceptions_app = Rails.application.routes
    end

    initializer 'pg_engine.set_factory_paths', after: 'factory_bot.set_factory_paths' do
      # Para que tome las factories de pg_engine/spec/factories
      # además de las de dummy/spec/factories
      FactoryBot.definition_file_paths << "#{root}/spec/factories"
    end

    initializer 'configurar_pg_rails' do
      # Ensure required env variables are set
      ENV.fetch('DEFAULT_MAIL_FROM')
      ENV.fetch('DEFAULT_MAIL_FROM_NAME')
      # SimpleForm
      require "#{PgEngine::Engine.root}/config/simple_form/simple_form"
      require "#{PgEngine::Engine.root}/config/simple_form/simple_form_bootstrap"

      # Rainbow
      Rainbow.enabled = true

      # Audited for ActiveAdmin
      require 'audited'
      ActiveSupport.on_load :active_record do
        Audited::Audit.class_eval do
          def self.ransackable_associations(_auth_object = nil)
            authorizable_ransackable_associations
          end

          def self.ransackable_attributes(_auth_object = nil)
            authorizable_ransackable_attributes
          end
        end
      end
    end

    initializer 'byebug_bullet' do
      if Rails.env.local?
        # Byebug
        # :nocov:
        if ENV['RUBY_DEBUG_OPEN']
          require 'byebug/core'
          begin
            Byebug.start_server 'localhost', ENV.fetch('BYEBUG_SERVER_PORT', 8989).to_i
            if ENV.fetch('SLEEP_AFTER_BYEBUG', false)
              puts 'waiting 3 secs after starting byebug server for connections'
              sleep 3
            end
          rescue Errno::EADDRINUSE
            Rails.logger.debug 'Byebug server already running'
          end
        end
        # :nocov:

        # Bullet
        Bullet.enable        = true
        Bullet.alert         = false
        Bullet.bullet_logger = true
        Bullet.console       = true
        Bullet.rails_logger  = true
        Bullet.add_footer    = true
      end
    end
  end
end
