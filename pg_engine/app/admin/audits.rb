ActiveAdmin.register Audited::Audit do
  actions :index, :show

  permit_params %i[auditable_id auditable_type associated_id associated_type user_id
                   user_type username action audited_changes version comment
                   remote_address request_uuid created_at]

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
    # column :username
    column :action
    # column :audited_changes
    column :version
    column :comment
    column :remote_address
    # column :request_uuid
    column :created_at
    actions
  end

  filter :auditable_id
  filter :auditable_type
  filter :associated_id
  filter :associated_type
  filter :user_id
  filter :user_type
  filter :username
  filter :action
  # filter :audited_changes
  filter :version
  filter :comment
  filter :remote_address
  filter :request_uuid
  filter :created_at

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
