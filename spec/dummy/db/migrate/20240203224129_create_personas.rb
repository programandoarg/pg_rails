# generado con pg_rails

class CreatePersonas < ActiveRecord::Migration[7.1]
  def change
    create_table :personas do |t|
      t.string :nombre
      t.string :apellido


      t.timestamps
    end

  end
end
