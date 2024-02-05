# generado con pg_rails

class CreateBlas < ActiveRecord::Migration[7.1]
  def change
    create_table :blas do |t|
      t.string :nombre, null: false
      t.integer :tipo, null: false
      t.references :categoria_de_cosa, index: true, null: false, foreign_key: true


      t.references :creado_por, index: true
      t.references :actualizado_por, index: true


      t.datetime :discarded_at

      t.timestamps
    end


    add_foreign_key :blas, :users, column: 'creado_por_id'
    add_foreign_key :blas, :users, column: 'actualizado_por_id'
  end
end
