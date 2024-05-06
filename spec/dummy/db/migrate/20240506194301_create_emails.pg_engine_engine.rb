# This migration comes from pg_engine_engine (originally 20240506194106)
# generado con pg_rails

class CreateEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :emails do |t|
      t.datetime :accepted_at
      t.datetime :delivered_at
      t.datetime :opened_at
      t.string :from_address, null: false
      t.string :from_name
      t.string :reply_to
      t.string :to, null: false
      t.string :subject
      t.string :body_input
      t.string :tags, array: true
      t.references :associated, polymorphic: true, index: true
      t.string :content_eml
      t.string :message_id
      t.string :mailer
      t.string :status_detail
      t.integer :status, null: false, default: 0


      t.references :creado_por, index: true
      t.references :actualizado_por, index: true


      t.timestamps
    end


    add_foreign_key :emails, :users, column: 'creado_por_id'
    add_foreign_key :emails, :users, column: 'actualizado_por_id'
  end
end
