# frozen_string_literal: true

# unless Rails.env.production?
#   # require 'byebug'
#   require 'factory_bot_rails'
# end

# require 'font-awesome-rails'
# require 'nested_form'
# require 'audited'
# # require 'best_in_place'
# # require 'bootstrap'
# # require 'bootstrap-datepicker-rails'
# require 'breadcrumbs_on_rails'
# require 'caxlsx_rails'
# require 'devise'
# require 'devise-i18n'
# require 'devise/orm/active_record'
# require 'draper'
# require 'enumerize'
# # require 'jquery-rails'
# require 'pundit'
# # require 'rails-assets-chosen'
# require 'rails-i18n'
# # require 'rollbar'
# # require 'selectize-rails'
# require 'simple_form'
# require 'slim'
# # require 'smart_listing'
# require 'kaminari'
# require 'kaminari-i18n'

require 'pg_rails/utils/logueador'

module PgRails
  class Engine < ::Rails::Engine
    isolate_namespace PgRails

    config.i18n.default_locale = :es
    config.time_zone = 'America/Argentina/Buenos_Aires'
  end
end
