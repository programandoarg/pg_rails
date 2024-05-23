ActiveAdmin.register EmailLog do
  permit_params :email_id, :log_id, :event, :log_level, :severity, :timestamp, :message_id

  index do
    selectable_column
    id_column
    column :email
    column :log_id
    column :event
    column :log_level
    column :severity
    column :timestamp
    column :message_id
    actions
  end

  filter :email
  filter :log_id
  filter :event
  filter :log_level
  filter :severity
  filter :timestamp
  filter :message_id

  form do |f|
    f.inputs do
      f.input :email
      f.input :log_id
      f.input :event
      f.input :log_level
      f.input :severity
      f.input :timestamp
      f.input :message_id
    end
    f.actions
  end
end
