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

group :development, :test do
  # FIXME: probar luego quitando esto
  gem 'rubocop', '~> 1.60.2'
  gem 'rubocop-rails', "~> 2.23.1"
  gem 'rubocop-rspec', "~> 2.26.1"
  gem 'slim_lint', "~> 0.26.0"
  gem 'ruby-lint', "~> 0.9.1"
  gem 'brakeman', "~> 6.1"
end
