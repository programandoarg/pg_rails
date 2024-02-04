# frozen_string_literal: true

# == Schema Information
#
# Table name: cosas
#
#  id                 :bigint           not null, primary key
#  apellido           :string
#  nombre             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  actualizado_por_id :bigint
#  creado_por_id      :bigint
#  persona_id         :bigint
#
# Indexes
#
#  index_cosas_on_actualizado_por_id  (actualizado_por_id)
#  index_cosas_on_creado_por_id       (creado_por_id)
#  index_cosas_on_persona_id          (persona_id)
#
# Foreign Keys
#
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (creado_por_id => users.id)
#  fk_rails_...  (persona_id => personas.id)
#

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
