# frozen_string_literal: true

# == Schema Information
#
# Table name: mensaje_contactos
#
#  id         :bigint           not null, primary key
#  email      :string
#  mensaje    :string
#  nombre     :string
#  telefono   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MensajeContacto < ApplicationRecord
  audited

  validates :nombre, :email, :mensaje, presence: true
end
