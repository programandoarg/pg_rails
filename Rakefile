require "bundler/setup"

def playchord
  system 'play -n synth pl G2 pl B2 pl D3 pl G3 pl D4 pl G4 delay 0 .05 .1 .15 .2 .25 remix - fade 0 4 .1 norm -1'
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
  system "bundle exec spring rspec #{PATHS_TO_TEST} #{args.to_a.join(' ')}"
end

desc "Preparar y testear"
task :test do
  system "yarn install"
  system "bundle exec rake db:test:prepare"
  # system "yarn build"
  # system "yarn build:css"
  system "yarn dummy:build"
  system "yarn dummy:build:css"
  Rake::Task['rspec'].invoke
end

desc "Testear sin spring"
task :rspec do
  abort unless system "CI=true bundle exec rspec #{PATHS_TO_TEST}"
end

desc "Static analysis"
task :static_analysis do
  abort unless system("overcommit --run") &&
               system("bundle exec brakeman -q --no-summary --skip-files node_modules/ --force")
end

desc "Brakeman interactive mode"
task :brakeman do
  system "bundle exec brakeman -q --no-summary --skip-files node_modules/ -I --force"
end

desc 'Pre push tasks'
task :prepush do
  if `git status -s` != ''
    system 'git add .'
    system 'git commit -m "Some changes that wasn\'t commited on prepush [automatic commit]"'
  end
  system 'bundle exec rubocop -a'
  system 'npx --no-install eslint --fix .'
  if `git status -s` != ''
    system 'git add .'
    system 'git commit -m "Lint on prepush [automatic commit]"'
  end
  Rake::Task['static_analysis'].invoke
  Rake::Task['test'].invoke
ensure
  playchord
end

desc 'Release all'
task :release_all do
  Rake::Task['release'].invoke
  system "npm pack --pack-destination pkg && npm publish"
end
