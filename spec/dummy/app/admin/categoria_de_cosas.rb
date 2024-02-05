ActiveAdmin.register CategoriaDeCosa do
  permit_params :discarded_at, :fecha, :nombre, :tiempo, :tipo, :created_at, :updated_at, :actualizado_por_id,
                :creado_por_id

  # :id
  # :discarded_at, :fecha, :nombre, :tiempo, :tipo, :created_at, :updated_at, :actualizado_por_id, :creado_por_id
  index do
    selectable_column
    id_column
    column :discarded_at
    column :fecha
    column :nombre
    column :tiempo
    column :tipo
    column :created_at
    column :updated_at
    column :actualizado_por_id
    column :creado_por_id
    actions
  end

  filter :fecha
  filter :nombre
  filter :tiempo
  filter :tipo

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :fecha
      f.input :tipo
      f.input :tiempo
    end
    f.actions
  end
end
