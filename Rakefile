require "bundler/setup"

def playchord(status)
  json_path = File.expand_path("spec/hooks/prepush-#{status}.json", ENV.fetch('PREPUSH_HOOK_JSON_DIR'))
  system "curl -X POST -d \"@#{json_path}\" -H \"Content-Type: application/json\" #{ENV.fetch('PREPUSH_HOOK_URL')}"
end

def system!(*args)
  system(*args, exception: true)
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)

load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"

task default: :test_spring

task :hola do
  puts 'holaaa'
end

PATHS_TO_TEST='spec pg_scaffold/spec pg_associable/spec pg_engine/spec pg_layout/spec'

desc "Testear rápido"
task :test_spring do |t, args|
  system! "bundle exec spring rspec --fail-fast #{PATHS_TO_TEST} #{args.to_a.join(' ')}"
end

desc "Preparar y testear"
task :test_prepare do
  system! "yarn install"
  system! "bundle exec rake db:test:prepare"
  system!("yarn build")
  system!("yarn build:css")
  system! "bundle exec rake app:assets:precompile"
  Rake::Task['rspec'].invoke
  system! "bundle exec rake app:assets:clobber"
end

desc "Testear sin spring"
task :rspec do
  system! "CI=true bundle exec rspec --fail-fast #{PATHS_TO_TEST}"
end

desc "Static analysis"
task :static_analysis do
  if `git status -s` != ''
    changes = `git diff --name-only`.split("\n").map {|f| f.split('/').last }.join(' ')
    system! 'git add .'
    system! "git commit -m \"[autocommit] #{changes}\""
  end
  system! 'bundle exec rubocop -a'
  system! 'npx --no-install eslint --fix .'
  if `git status -s` != ''
    changes = `git diff --name-only`.split("\n").map {|f| f.split('/').last }.join(' ')
    system! 'git add .'
    system! "git commit -m \"[autolint] #{changes}\""
  end
  system!("overcommit --run")
  system!("bundle exec brakeman -q --no-summary --skip-files node_modules/ --force")
end

desc "Brakeman interactive mode"
task :brakeman do
  system "bundle exec brakeman -q --no-summary --skip-files node_modules/ -I --force"
end

desc 'Pre push tasks'
task :prepush do
  Rake::Task['static_analysis'].invoke
  Rake::Task['test_prepare'].invoke
  playchord('success')
rescue
  playchord('failed')
end

desc 'Release all'
task :release_all do
  Rake::Task['release'].invoke
  system! "npm pack --pack-destination pkg && npm publish"
end

desc 'Alias for `rails routes`, to Annotate to use.'
task :routes do
  require_relative "spec/dummy/config/environment"
  require 'rails/commands/routes/routes_command'
  Rails::Command::RoutesCommand.new.perform
end
