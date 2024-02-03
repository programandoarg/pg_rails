# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :persona do
    nombre { Faker::Lorem.sentence }
    apellido { Faker::Lorem.sentence }
  end
end
