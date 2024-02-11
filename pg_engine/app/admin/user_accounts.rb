ActiveAdmin.register UserAccount do
  decorate_with UserAccountDecorator
  permit_params :user_id, :account_id, profiles: []

  index do
    selectable_column
    id_column
    column :user
    column :account
    column :profiles
    actions
  end

  filter :user
  filter :account
  filter :profiles

  form do |f|
    f.inputs do
      f.input :user
      f.input :account
      f.input :profiles, as: :select
    end
    f.actions
  end
end
