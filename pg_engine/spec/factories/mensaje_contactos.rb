# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :mensaje_contacto do
    nombre { Faker::Lorem.sentence }
    email { Faker::Lorem.sentence }
    telefono { Faker::Lorem.sentence }
    mensaje { Faker::Lorem.sentence }
  end
end
