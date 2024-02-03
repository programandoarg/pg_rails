# frozen_string_literal: true

# generado con pg_rails

class Cosa < ApplicationRecord

  belongs_to :persona, optional: true

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  scope :query, ->(param) { param.present? ? where(id: param) : all } # TODO: completar
end
