class RemoveHashIds < ActiveRecord::Migration[7.1]
  def change
    remove_column :accounts, :hashid
  end
end
