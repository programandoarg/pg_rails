module PgEngine
  class DeviseController < ApplicationController
    before_action :configure_permitted_parameters

    layout :layout_by_resource

    def layout_by_resource
      if controller_name == 'registrations' && action_name.in?(%w[edit update])
        'pg_layout/layout'
      else
        'pg_layout/devise'
      end
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:nombre, :apellido])
      devise_parameter_sanitizer.permit(:account_update, keys: [:nombre, :apellido])
    end
  end
end
