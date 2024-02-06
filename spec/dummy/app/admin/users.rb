ActiveAdmin.register User do
  decorate_with UserDecorator
  permit_params :email, :password, :password_confirmation, :confirmed_at, profiles: []

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :created_at
    actions
  end
  filter :email
  # filter :current_sign_in_at
  # filter :created_at

  form do |f|
    f.inputs do
      if params[:change_password]
        f.input :password
        # f.input :password_confirmation
      else
        f.input :email
        if !f.object.persisted?
          f.input :password
        end
        f.input :profiles, as: :select
      end
      # f.input :password_confirmation
    end
    f.actions
  end

  before_update do |user|
    user.skip_reconfirmation!
  end
  after_build do |user|
    if action_name == 'create'
      user.skip_confirmation!
    end
  end

  member_action :discard, method: :put do
    resource.discard!
    redirect_to resource_path, notice: "Discarded!"
  end

  member_action :restore, method: :put do
    resource.undiscard!
    redirect_to resource_path, notice: "Restored!"
  end

  action_item :view, only: :show do
    link_to 'Discard', discard_active_admin_user_path(resource), method: :put if resource.kept?
  end

  action_item :view, only: :show do
    link_to 'Restore', restore_active_admin_user_path(resource), method: :put if resource.discarded?
  end

  action_item :view, only: :show do
    link_to 'Cambiar contraseña', edit_active_admin_user_path(resource, change_password: true)
  end
end
