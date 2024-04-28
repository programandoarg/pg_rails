# This migration comes from pg_engine_engine (originally 20240428152916)
# generado con pg_rails

class CreateMensajeContactos < ActiveRecord::Migration[7.1]
  def change
    create_table :mensaje_contactos do |t|
      t.string :nombre
      t.string :email
      t.string :telefono
      t.string :mensaje

      t.timestamps
    end

  end
end
