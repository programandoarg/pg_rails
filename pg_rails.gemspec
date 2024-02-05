# frozen_string_literal: true

# Maintain your gem's version:
require_relative "lib/version"

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

  # spec.require_paths = ['lib', 'pg_engine/lib', 'pg_associable/lib', 'pg_scaffold/lib', 'pg_layout/lib']
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against ' \
  #     'public gem pushes.'
  # end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
end
