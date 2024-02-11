# This migration comes from pg_engine_engine (originally 20240211153049)
# generado con pg_rails

class CreateUserAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :user_accounts do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.references :account, index: true, null: false, foreign_key: true
      t.integer :profiles, array: true, null: false, default: []

      t.references :creado_por, index: true
      t.references :actualizado_por, index: true

      t.timestamps
    end


    add_foreign_key :user_accounts, :users, column: 'creado_por_id'
    add_foreign_key :user_accounts, :users, column: 'actualizado_por_id'
  end
end
