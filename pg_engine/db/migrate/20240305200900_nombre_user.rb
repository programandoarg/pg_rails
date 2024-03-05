class NombreUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nombre, :string, null: false
    add_column :users, :apellido, :string, null: false
  end
end
