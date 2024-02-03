# frozen_string_literal: true

# generado con pg_rails

class Persona < ApplicationRecord
  audited

  scope :query, ->(param) { param.present? ? where(id: param) : all } # TODO: completar
end
