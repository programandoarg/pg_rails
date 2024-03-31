class Users::RegistrationsController < Devise::RegistrationsController
  def after_inactive_sign_up_path_for(resource)
    flash[:toast] = false
    super(resource)
  end
end
