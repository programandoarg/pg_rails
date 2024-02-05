class ApplicationController < PgEngine::SignedInController
  before_action do
    load "#{PgEngine::Engine.root}/config/simple_form/simple_form.rb"
    load "#{PgEngine::Engine.root}/config/simple_form/simple_form_bootstrap.rb"
  end
end
