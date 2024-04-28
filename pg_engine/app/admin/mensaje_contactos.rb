ActiveAdmin.register MensajeContacto do
  permit_params :nombre, :email, :telefono, :mensaje

  index do
    selectable_column
    id_column
    column :nombre
    column :email
    column :telefono
    column :mensaje
    actions
  end

  filter :nombre
  filter :email
  filter :telefono
  filter :mensaje

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :email
      f.input :telefono
      f.input :mensaje
    end
    f.actions
  end
end
