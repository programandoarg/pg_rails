# generado con pg_rails

class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.integer :plan, null: false
      t.string :nombre, null: false
      t.string :hashid


      t.references :creado_por, index: true
      t.references :actualizado_por, index: true


      t.datetime :discarded_at

      t.timestamps
    end


    add_foreign_key :accounts, :users, column: 'creado_por_id'
    add_foreign_key :accounts, :users, column: 'actualizado_por_id'
  end
end
