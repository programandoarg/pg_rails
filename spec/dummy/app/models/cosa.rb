# frozen_string_literal: true

# == Schema Information
#
# Table name: cosas
#
#  id                   :bigint           not null, primary key
#  discarded_at         :datetime
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

class Cosa < ApplicationRecord
  audited
  include Discard::Model

  self.default_modal = true
  self.inline_editable_fields = %i[nombre tipo categoria_de_cosa]

  # Conviene tener account_id en todos los modelos aunque estén
  # el tenant sea deducible a través de sus asociaciones (ej:
  # categoría)
  #   * Para facilitar las queries
  acts_as_tenant :account
  tenantable_belongs_to :categoria_de_cosa, assign_tenant_from_associated: true

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  has_rich_text :rico

  scope :kept, -> { undiscarded.joins(:categoria_de_cosa).merge(CategoriaDeCosa.kept) }

  def kept?
    undiscarded? && (categoria_de_cosa.blank? || categoria_de_cosa.kept?)
  end

  enumerize :tipo, in: { completar: 0, los: 1, valores: 2 }

  validates :nombre, :tipo, presence: true

  scope :order_by_categoria_de_cosa, lambda { |direction|
    joins(:categoria_de_cosa).order('categoria_de_cosas.nombre': direction)
  }
end
