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
# generado con pg_rails

class CategoriaDeCosa < ApplicationRecord
  audited
  include Discard::Model

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  enumerize :tipo, in: { completar: 0, los: 1, valores: 2 }

  scope :query, ->(param) { param.present? ? where(id: param) : all } # TODO: completar

  validates :nombre, :tipo, presence: true
end
