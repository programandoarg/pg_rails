ActiveAdmin.register Email do
  permit_params :accepted_at, :delivered_at, :opened_at, :from_address, :from_name, :reply_to, :to, :subject, :body_input, :tags, :associated_id, :associated_type, :content_eml, :message_id, :mailer, :status_detail, :status

  index do
    selectable_column
    id_column
    column :accepted_at
    column :delivered_at
    column :opened_at
    column :from_address
    column :from_name
    column :reply_to
    column :to
    column :subject
    column :body_input
    column :tags
    column :associated
    column :content_eml
    column :message_id
    column :mailer
    column :status_detail
    column :status
    actions
  end

  filter :accepted_at
  filter :delivered_at
  filter :opened_at
  filter :from_address
  filter :from_name
  filter :reply_to
  filter :to
  filter :subject
  filter :body_input
  filter :tags
  filter :associated
  filter :content_eml
  filter :message_id
  filter :mailer
  filter :status_detail
  filter :status

  form do |f|
    f.inputs do
      f.input :accepted_at
      f.input :delivered_at
      f.input :opened_at
      f.input :from_address
      f.input :from_name
      f.input :reply_to
      f.input :to
      f.input :subject
      f.input :body_input
      f.input :tags
      f.input :associated
      f.input :content_eml
      f.input :message_id
      f.input :mailer
      f.input :status_detail
      f.input :status
    end
    f.actions
  end
end
