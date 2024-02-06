ActiveAdmin.register CategoriaDeCosa do
  permit_params :nombre, :tipo, :fecha, :tiempo

  index do
    selectable_column
    id_column
    column :nombre
    column :tipo
    column :fecha
    column :tiempo
    actions
  end

  filter :nombre
  filter :tipo
  filter :fecha
  filter :tiempo

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :tipo
      f.input :fecha
      f.input :tiempo
    end
    f.actions
  end
end
