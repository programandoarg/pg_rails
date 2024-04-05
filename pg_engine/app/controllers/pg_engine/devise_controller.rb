module PgEngine
  class DeviseController < ApplicationController
    before_action :configure_permitted_parameters

    layout :layout_by_user

    protected

    def layout_by_user
      user_signed_in? ? 'pg_layout/containerized' : 'pg_layout/devise'
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[nombre apellido])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[nombre apellido])
    end
  end
end
