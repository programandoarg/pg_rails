# generado con pg_rails

class CreateCategoriaDeCosas < ActiveRecord::Migration[7.1]
  def change
    create_table :categoria_de_cosas do |t|
      t.string :nombre, null: false
      t.integer :tipo, null: false
      t.date :fecha
      t.datetime :tiempo


      t.references :creado_por, index: true
      t.references :actualizado_por, index: true


      t.datetime :discarded_at

      t.timestamps
    end


    add_foreign_key :categoria_de_cosas, :users, column: 'creado_por_id'
    add_foreign_key :categoria_de_cosas, :users, column: 'actualizado_por_id'
  end
end
