# frozen_string_literal: true

# generado con pg_rails

class UserAccount < ApplicationRecord
  audited

  belongs_to :user
  belongs_to :account

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  enumerize :profiles, in: {
    admin: 1,
    dueño: 2,
    invitado: 3
  }, multiple: true

  validates :user, :account, presence: true
end
