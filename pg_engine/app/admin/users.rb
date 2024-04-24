ActiveAdmin.register User do
  decorate_with UserDecorator
  permit_params :email, :password, :password_confirmation, :confirmed_at

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :created_at
    column :confirmed_at
    column :developer
    actions
  end
  filter :email

  form do |f|
    f.inputs do
      if params[:change_password]
        f.input :password
      else
        f.input :email
        f.input :password unless f.object.persisted?
      end
    end
    f.actions
  end

  before_update(&:skip_reconfirmation!)
  after_build do |user|
    user.skip_confirmation! if action_name == 'create'
  end

  member_action :confirm, method: :put do
    resource.update(confirmed_at: Time.zone.now)
    redirect_to resource_path, notice: 'Confirmed!'
  end

  member_action :discard, method: :put do
    resource.discard!
    redirect_to resource_path, notice: 'Discarded!'
  end

  member_action :restore, method: :put do
    resource.undiscard!
    redirect_to resource_path, notice: 'Restored!'
  end

  action_item :view, only: :show do
    link_to 'Discard', discard_active_admin_user_path(resource), method: :put if resource.kept?
  end

  action_item :view, only: :show do
    link_to 'Confirm', confirm_active_admin_user_path(resource), method: :put if resource.kept?
  end

  action_item :view, only: :show do
    link_to 'Restore', restore_active_admin_user_path(resource), method: :put if resource.discarded?
  end

  action_item :view, only: :show do
    link_to 'Cambiar contraseña', edit_active_admin_user_path(resource, change_password: true)
  end
end
