module PgEngine
  class DeviseController < ApplicationController
    before_action :configure_permitted_parameters

    layout :layout_by_resource

    before_action do
      @sidebar = edit_registration?
    end

    protected

    def layout_by_resource
      edit_registration? ? 'pg_layout/containerized' : 'pg_layout/devise'
    end

    def edit_registration?
      controller_name == 'registrations' && action_name.in?(%w[edit update])
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[nombre apellido])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[nombre apellido])
    end
  end
end
