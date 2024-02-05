class ApplicationController < PgRails::SignedInController

  before_action do
    load "#{PgRails::Engine.root}/../simple_form/simple_form.rb"
    load "#{PgRails::Engine.root}/../simple_form/simple_form_bootstrap.rb"
  end

  layout 'pg_layout/layout'
end
