unless Rails.env.production?
  require 'byebug'
end

require "nested_form"
require 'audited'
require 'best_in_place'
require 'bootstrap'
require 'bootstrap-datepicker-rails'
require 'breadcrumbs_on_rails'
require 'caxlsx_rails'
require 'rails-assets-chosen'
require 'devise'
require 'devise/orm/active_record'
require 'draper'
require 'enumerize'
require 'font-awesome-rails'
require 'jquery-rails'
require 'paranoia'
require 'pundit'
require 'rails-i18n'
require 'rollbar'
require 'selectize-rails'
require 'simple_form'
require 'slim'

module PgRails
  class Engine < ::Rails::Engine
    isolate_namespace PgRails

    config.i18n.default_locale = :es

    initializer 'configurar_generators', after: "factory_bot.set_fixture_replacement" do
      unless Rails.env.production?
        require 'pg_rails/monkey_patches/mejoras_de_atributos'
        require 'pg_rails/monkey_patches/mejoras_a_named_base'
      end

      require 'pg_rails/utils/filtros_builder'
      require 'pg_rails/utils/filtros'
      require 'pg_rails/utils/logueador'
      require 'pg_rails/simple_form/initializer'
      require 'pg_rails/simple_form/pg_form_builder'

      config.generators do |g|
        g.test_framework :pg_rspec
        g.orm :pg_active_record

        g.fallbacks[:pg_rspec] = :rspec
        g.fallbacks[:pg_active_record] = :active_record
      end

      config.app_generators do |g|
        g.test_framework :pg_rspec
        g.orm :pg_active_record

        g.fallbacks[:pg_rspec] = :rspec
        g.fallbacks[:pg_active_record] = :active_record
      end
    end

    if Rails.env.test?
      initializer 'configuracion_rspec' do
        require 'pg_rails/utils/configurador_rspec'
      end
    end
  end
end
