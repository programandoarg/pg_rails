# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :categoria_de_cosa do
    nombre { Faker::Lorem.sentence }
    tipo { CategoriaDeCosa.tipo.values.sample }
    fecha { Faker::Date.backward }
    tiempo { "2024-02-06 14:56:04" }
  end
end
