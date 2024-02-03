# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :cosa do
    nombre { Faker::Lorem.sentence }
    apellido { Faker::Lorem.sentence }
    persona

    trait :persona_existente do
      persona { nil }
      persona_id { Persona.pluck(:id).sample }
    end
  end
end
