# This migration comes from pg_engine_engine (originally 20240208234111)
class Unaccent < ActiveRecord::Migration[7.1]
  def change
    enable_extension "unaccent"
  end
end
