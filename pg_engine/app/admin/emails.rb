ActiveAdmin.register Email do
  actions :index, :show
  index do
    selectable_column
    id_column
    column :from_address
    column :to
    column :subject
    column :body_input
    column :tags
    column :associated
    column :status
    actions
  end

  filter :from_address
  filter :to
  filter :tags
  filter :message_id
  filter :mailer
  filter :status
end
