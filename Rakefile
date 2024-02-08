require "bundler/setup"

require "bundler/gem_tasks"

task default: :test_spring

task :hola do
  puts 'holaaa'
end

PATHS_TO_TEST='spec pg_scaffold/spec'

desc "Testear rápido"
task :test_spring do
  require_relative "spec/dummy/config/application"
  system "bundle exec spring rspec #{PATHS_TO_TEST}"
end

desc "Preparar y testear"
task :test do
  require_relative "spec/dummy/config/application"
  system "yarn install"
  FileUtils.chdir "spec/dummy"
  system "bundle exec rails db:test:prepare"
  system "yarn install"
  system "yarn build"
  system "yarn build:css"
  FileUtils.chdir "../.."
  system "bundle exec rspec #{PATHS_TO_TEST}"
end

desc "Testear sin spring"
task :rspec do
  require_relative "spec/dummy/config/application"
  system "bundle exec rspec #{PATHS_TO_TEST}"
end

desc "Static analysis"
task :static_analysis do
  system "overcommit --run"
  system "bundle exec brakeman -q --no-summary --skip-files node_modules/ --force"
end

desc "Brakeman interactive mode"
task :brakeman do
  system "bundle exec brakeman -q --no-summary --skip-files node_modules/ -I --force"
end

desc 'Pre push tasks'
task :prepush do
  Rake::Task['static_analysis'].invoke
  Rake::Task['test'].invoke
end
