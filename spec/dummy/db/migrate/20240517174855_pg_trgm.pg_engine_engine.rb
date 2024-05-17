# This migration comes from pg_engine_engine (originally 20240517174821)
class PgTrgm < ActiveRecord::Migration[7.1]
  def change
    enable_extension "pg_trgm"
  end
end
