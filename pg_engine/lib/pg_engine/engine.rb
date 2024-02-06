# frozen_string_literal: true

module PgEngine
  class Engine < ::Rails::Engine
    isolate_namespace PgEngine

    config.i18n.default_locale = :es
    config.time_zone = 'America/Argentina/Buenos_Aires'

    initializer 'configurar_pg_rails' do
      # SimpleForm
      require "#{PgEngine::Engine.root}/config/simple_form/simple_form"
      require "#{PgEngine::Engine.root}/config/simple_form/simple_form_bootstrap"

      # Rainbow
      Rainbow.enabled = true

      # Audited for ActiveAdmin
      require 'audited'
      ActiveSupport.on_load :active_record do
        Audited::Audit.class_eval do
          def self.ransackable_attributes(_auth_object = nil)
            columns.map(&:name)
          end
        end
      end

      if Rails.env.development?
        # Byebug
        require 'byebug/core'
        begin
          Byebug.start_server 'localhost', ENV.fetch('BYEBUG_SERVER_PORT', 8989).to_i
        rescue Errno::EADDRINUSE
          Rails.logger.debug 'Byebug server already running'
        end

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
