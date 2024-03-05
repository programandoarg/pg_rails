# This migration comes from pg_engine_engine (originally 20240305200900)
class NombreUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nombre, :string, null: false
    add_column :users, :apellido, :string, null: false
  end
end
