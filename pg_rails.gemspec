# frozen_string_literal: true

# Maintain your gem's version:
require_relative "pg_rails/lib/version"

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

  spec.require_paths = ['pg_rails/lib', 'pg_associable/lib', 'pg_engine/lib', 'pg_layout/lib', 'pg_scaffold/lib']

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = ": Set to 'http://mygemserver.com'"
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against ' \
  #     'public gem pushes.'
  # end

  spec.add_dependency "rails", "~> 7.1.3.2"
  spec.add_dependency "anycable", "= 1.5.0"
  spec.add_dependency "anycable-rails", "~> 1.5.1"
  spec.add_dependency "anycable-rails-jwt", "~> 0.2.0"
  spec.add_dependency "cable_ready", "~> 5.0"

  # Use Redis adapter to run Action Cable in production
  spec.add_dependency "redis", "~> 5.1"

  spec.files = Dir['{pg_associable,pg_engine,pg_layout,pg_scaffold,pg_rails}/**/*', 'MIT-LICENSE', 'README.md']
end
