# generado con pg_rails

class CreateEmailLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :email_logs do |t|
      t.references :email, foreign_key: true
      t.string :log_id
      t.string :event
      t.string :log_level
      t.string :severity
      t.bigint :timestamp
      t.string :message_id


      t.timestamps
    end

  end
end
