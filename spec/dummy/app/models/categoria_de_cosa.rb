# frozen_string_literal: true

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
