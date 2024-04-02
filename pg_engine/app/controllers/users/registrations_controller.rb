module Users
  class RegistrationsController < Devise::RegistrationsController
    # POST /resource
    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          expire_data_after_sign_in!
          render_message
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    def render_message
      msg = <<~HTML
        <div class="alert alert-info">
          #{I18n.t 'devise.registrations.signed_up_but_unconfirmed'}
        </div>
      HTML
      render turbo_stream: turbo_stream.update('form-signup', msg)
    end
  end
end
