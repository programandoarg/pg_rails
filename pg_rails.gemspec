# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('pg_engine/lib', __dir__)
$LOAD_PATH.push File.expand_path('pg_associable/lib', __dir__)
$LOAD_PATH.push File.expand_path('pg_scaffold/lib', __dir__)

# Maintain your gem's version:
require 'pg_rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name                  = 'pg_rails'
  spec.version               = PgRails::VERSION
  spec.authors               = ['Martín Rosso']
  spec.email                 = ['mrosso10@gmail.com']
  spec.homepage              = 'https://github.com/programandoarg/pg_rails'
  spec.summary               = 'Rails goodies'
  spec.description           = 'Rails goodies.'
  spec.license               = 'MIT'
  spec.required_ruby_version = '~> 3.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against ' \
  #     'public gem pushes.'
  # end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  # TODO: add pg_associable
  # spec.add_development_dependency 'pg_associable', '~> 5.0'

  spec.add_development_dependency 'caxlsx_rails'

  spec.add_development_dependency 'draper'

  spec.add_development_dependency 'pg', '~> 1.1'

  spec.add_development_dependency "rails", "~> 7.1.3"

  spec.add_development_dependency 'rainbow'

  spec.add_development_dependency 'simple_form'

  # User manamement
  spec.add_development_dependency 'devise'
  spec.add_development_dependency 'devise-i18n'

  # Rails internationalization
  spec.add_development_dependency 'rails-i18n'

  # Slim template
  spec.add_development_dependency 'slim-rails'

  # Better enums
  spec.add_development_dependency 'enumerize'

  # XML parsing
  spec.add_development_dependency 'nokogiri'

  # Pagination
  spec.add_development_dependency 'kaminari'
  spec.add_development_dependency 'kaminari-i18n'

  # Breadcrumbs
  spec.add_development_dependency 'breadcrumbs_on_rails'

  # Soft deletion
  spec.add_development_dependency 'discard'

  # DB Audition
  spec.add_development_dependency "audited", "~> 5.0"

  # Access policies
  spec.add_development_dependency 'pundit'





  # Simplecov
  spec.add_development_dependency 'simplecov', '~> 0.17.1'

  # Spring
  spec.add_development_dependency 'spring'
  spec.add_development_dependency 'spring-commands-rspec'

  # Rspec
  spec.add_development_dependency 'rspec-rails', '~> 6.0.0'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'fuubar'
  spec.add_development_dependency 'faker'

  # # VCR
  # spec.add_development_dependency 'vcr'
  # spec.add_development_dependency 'webmock'

  # # Capybara
  # spec.add_development_dependency 'capybara'
  # spec.add_development_dependency 'selenium-webdriver'

  # Bullet
  spec.add_development_dependency 'bullet'

  # Linters
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'rubocop-rspec'


  spec.add_development_dependency "puma"

  spec.add_development_dependency "sprockets-rails"

  spec.add_development_dependency "jsbundling-rails", "~> 1.3"

  spec.add_development_dependency "turbo-rails", "~> 1.5"

end
