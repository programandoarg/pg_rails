$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "pg_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "pg_rails"
  spec.version     = PgRails::VERSION
  spec.authors     = ["Martín Rosso"]
  spec.email       = ["mrosso10@gmail.com"]
  spec.homepage    = ""
  spec.summary     = ": Summary of PgRails."
  spec.description = ": Description of PgRails."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'audited', '~> 4.7'
  spec.add_dependency 'best_in_place', '~> 3.1.1'
  spec.add_dependency 'bootstrap', '~> 4.3.1'
  spec.add_dependency 'bootstrap-datepicker-rails'
  spec.add_dependency 'breadcrumbs_on_rails'
  spec.add_dependency 'caxlsx_rails'
  spec.add_dependency 'devise'
  spec.add_dependency 'draper'
  spec.add_dependency 'enumerize'
  spec.add_dependency 'font-awesome-rails'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'nested_form'
  spec.add_dependency 'paranoia'
  spec.add_dependency 'pg'
  spec.add_dependency 'pundit'
  spec.add_dependency 'rails', '~> 5.2.3'
  spec.add_dependency 'rails-i18n'
  spec.add_dependency 'rainbow'
  spec.add_dependency 'rollbar'
  spec.add_dependency 'sass-rails', '~> 5.0.4'
  spec.add_dependency 'selectize-rails'
  spec.add_dependency 'simple_form'
  spec.add_dependency 'slim-rails'


  spec.add_development_dependency 'annotate'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
  spec.add_development_dependency 'simplecov'
end
