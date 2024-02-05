# frozen_string_literal: true

module PgRails
  class Engine < ::Rails::Engine
    isolate_namespace PgRails

    config.i18n.default_locale = :es
    config.time_zone = 'America/Argentina/Buenos_Aires'

    initializer 'configurar_simple_form' do
      require "#{PgRails::Engine.root}/../simple_form/simple_form"
      require "#{PgRails::Engine.root}/../simple_form/simple_form_bootstrap"
    end
  end
end
