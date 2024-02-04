# frozen_string_literal: true

module PgRails
  class Engine < ::Rails::Engine
    isolate_namespace PgRails

    config.i18n.default_locale = :es
    config.time_zone = 'America/Argentina/Buenos_Aires'
  end
end
