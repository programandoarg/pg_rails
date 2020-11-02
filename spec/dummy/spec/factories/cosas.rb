# == Schema Information
#
# Table name: cosas
#
#  id                   :bigint           not null, primary key
#  deleted_at           :datetime
#  nombre               :string           not null
#  tipo                 :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  actualizado_por_id   :bigint
#  categoria_de_cosa_id :bigint           not null
#  creado_por_id        :bigint
#
# Indexes
#
#  index_cosas_on_actualizado_por_id    (actualizado_por_id)
#  index_cosas_on_categoria_de_cosa_id  (categoria_de_cosa_id)
#  index_cosas_on_creado_por_id         (creado_por_id)
#
# Foreign Keys
#
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (categoria_de_cosa_id => categoria_de_cosas.id)
#  fk_rails_...  (creado_por_id => users.id)
#

FactoryBot.define do
  factory :cosa do
    nombre { Faker::Lorem.sentence }
    tipo { Cosa.tipo.values.sample }
    association :categoria_de_cosa, factory: :categoria_de_cosa

    trait :categoria_de_cosa_existente do
      categoria_de_cosa { nil }
      categoria_de_cosa_id { CategoriaDeCosa.all.pluck(:id).sample }
    end
  end
end
