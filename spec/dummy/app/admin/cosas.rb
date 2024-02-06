ActiveAdmin.register Cosa do
  permit_params :nombre, :tipo, :categoria_de_cosa

  index do
    selectable_column
    id_column
    column :nombre
    column :tipo
    column :categoria_de_cosa
    actions
  end

  filter :nombre
  filter :tipo
  filter :categoria_de_cosa

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :tipo
      f.input :categoria_de_cosa
    end
    f.actions
  end
end
