module PgEngine
  class DeviseController < ApplicationController
    layout 'pg_layout/devise'

    before_action do
      render(layout: 'pg_layout/layout') if controller_name == 'registrations' && action_name == 'edit'
    end
  end
end
