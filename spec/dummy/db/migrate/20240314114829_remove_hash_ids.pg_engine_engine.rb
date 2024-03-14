# This migration comes from pg_engine_engine (originally 20240314114503)
class RemoveHashIds < ActiveRecord::Migration[7.1]
  def change
    remove_column :accounts, :hashid
  end
end
