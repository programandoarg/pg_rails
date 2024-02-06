ActiveAdmin.register Bla do
  permit_params :discarded_at, :nombre, :tipo, :categoria_de_cosa_id
  # :id
  # :discarded_at, :fecha, :nombre, :tiempo, :tipo, :created_at, :updated_at, :actualizado_por_id, :creado_por_id
  index do
    selectable_column
    id_column
    column :nombre
    column :tipo
    column :categoria_de_cosa
    actions
  end

  # filter :fecha
  filter :nombre
  # filter :tiempo
  # filter :tipo

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :tipo, as: :select
      f.input :categoria_de_cosa
    end
    f.actions
  end
end
