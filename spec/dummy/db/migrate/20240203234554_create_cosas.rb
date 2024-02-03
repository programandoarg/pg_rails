# generado con pg_rails

class CreateCosas < ActiveRecord::Migration[7.1]
  def change
    create_table :cosas do |t|
      t.string :nombre
      t.string :apellido
      t.references :persona, foreign_key: true


      t.references :creado_por, index: true
      t.references :actualizado_por, index: true


      t.timestamps
    end


    add_foreign_key :cosas, :users, column: 'creado_por_id'
    add_foreign_key :cosas, :users, column: 'actualizado_por_id'
  end
end
