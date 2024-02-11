# frozen_string_literal: true

# generado con pg_rails

class Account < ApplicationRecord
  audited
  include Discard::Model

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  enumerize :plan, in: { completar: 0, los: 1, valores: 2 }

  validates :plan, :nombre, presence: true
end
