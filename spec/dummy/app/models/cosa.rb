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
# generado con pg_rails

class Cosa < ApplicationRecord
  audited
  acts_as_paranoid without_default_scope: true

  belongs_to :categoria_de_cosa

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  enumerize :tipo, in: { completar: 0, los: 1, valores: 2}

  validates :nombre, :tipo, :categoria_de_cosa, presence: true
end
