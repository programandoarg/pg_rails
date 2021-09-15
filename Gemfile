source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in pg_rails.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
gem 'smart_listing', git: 'https://github.com/mrosso10/smart_listing.git', ref: '152972758263f7d8688ade59ccc68beb7fca1c20'
# gem 'smart_listing', path: '/proyectos/tmp/smart_listing'

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery-validation'
end

gem "best_in_place", git: "https://github.com/bernat/best_in_place"

gem 'paranoia'
gem 'discard'

group :development, :test do
  gem 'fuubar'
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'rails-controller-testing'

  gem "brakeman", require: false
  gem "bundler-audit", require: false
end
