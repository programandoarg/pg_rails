ActiveAdmin.register Audited::Audit do
  # permit_params :discarded_at, :fecha, :nombre, :tiempo, :tipo, :created_at, :updated_at, :actualizado_por_id, :creado_por_id

  # :id
  # :discarded_at, :fecha, :nombre, :tiempo, :tipo, :created_at, :updated_at, :actualizado_por_id, :creado_por_id

  index do
    selectable_column
    id_column
    column :auditable_id
    column :auditable_type
    # column :associated_id
    # column :associated_type
    column :user_id
    # column :user_type
    column :username
    column :action
    # column :audited_changes
    # column :version
    # column :comment
    # column :remote_address
    # column :request_uuid
    column :created_at
    actions
  end

  filter :id
  filter :nombre
  # filter :tiempo
  # filter :tipo

  # form do |f|
  #   f.inputs do
  #     f.input :nombre
  #     f.input :fecha
  #     f.input :tipo
  #     f.input :tiempo
  #   end
  #   f.actions
  # end
end
