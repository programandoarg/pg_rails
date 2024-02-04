# frozen_string_literal: true

# == Schema Information
#
# Table name: personas
#
#  id         :bigint           not null, primary key
#  apellido   :string
#  nombre     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# generado con pg_rails

class Persona < ApplicationRecord
  # audited

  scope :query, ->(param) { all } # TODO: completar
end
