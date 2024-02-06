# frozen_string_literal: true

# == Schema Information
#
# Table name: categoria_de_cosas
#
#  id                 :bigint           not null, primary key
#  discarded_at       :datetime
#  fecha              :date
#  nombre             :string           not null
#  tiempo             :datetime
#  tipo               :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  actualizado_por_id :bigint
#  creado_por_id      :bigint
#
# Indexes
#
#  index_categoria_de_cosas_on_actualizado_por_id  (actualizado_por_id)
#  index_categoria_de_cosas_on_creado_por_id       (creado_por_id)
#
# Foreign Keys
#
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (creado_por_id => users.id)
#

FactoryBot.define do
  factory :categoria_de_cosa do
    nombre { Faker::Lorem.sentence }
    tipo { CategoriaDeCosa.tipo.values.sample }
    fecha { Faker::Date.backward }
    tiempo { '2024-02-06 16:10:19' }
  end
end
