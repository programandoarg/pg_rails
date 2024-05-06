# frozen_string_literal: true

require_relative 'pg_engine/engine'
require_relative 'pg_engine/core_ext'
require_relative 'pg_engine/error'
require_relative 'pg_engine/configuracion'
require_relative 'pg_engine/email_observer'
require_relative 'pg_engine/route_helpers'
require_relative 'pg_engine/utils/pg_logger'
require_relative 'pg_engine/utils/pdf_preview_generator'

require_relative '../app/helpers/pg_engine/print_helper'

require 'rails'
require 'anycable'
require 'anycable-rails'
require 'anycable-rails-jwt'
require 'cable_ready'
require 'caxlsx_rails'
require 'draper'
require 'pg'
require 'rainbow'
require 'simple_form'
require 'devise'
require 'devise-i18n'
require 'rails-i18n'
require 'slim-rails'
require 'enumerize'
require 'nokogiri'
require 'kaminari'
require 'kaminari-i18n'
require 'breadcrumbs_on_rails'
require 'discard'
require 'audited'
require 'pundit'
require 'dotenv-rails'
require 'faker'
require 'puma'
require 'rollbar'
require 'sprockets/rails'
require 'jsbundling-rails'
require 'cssbundling-rails'
require 'turbo-rails'
require 'activeadmin'
require 'sassc'
require 'image_processing'
require 'hashid/rails'
require 'redis'

if Rails.env.local?
  require 'letter_opener'
  require 'overcommit'
  require 'database_cleaner-active_record'
  require 'byebug'
  require 'annotate'
  require 'bullet'
  require 'rubocop'
  require 'rubocop-rails'
  require 'rubocop-rspec'
  require 'slim_lint'
  require 'ruby-lint'
  require 'brakeman'
  require 'capybara'
  require 'selenium-webdriver'
  require 'simplecov'
  # require 'spring'
  # require 'spring-commands-rspec'
  require 'rspec-rails'
  require 'factory_bot_rails'
  require 'rails-controller-testing'
end

module PgEngine
  class << self
    attr_writer :configuracion

    def configuracion
      @configuracion ||= Configuracion.new
    end

    def config
      configuracion
    end

    def configurar
      yield(configuracion)
    end
  end
end
