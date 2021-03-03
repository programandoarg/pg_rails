# frozen_string_literal: true

class Users < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :profiles

      t.timestamps
    end
  end
end
