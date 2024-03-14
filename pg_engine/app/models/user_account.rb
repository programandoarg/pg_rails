# frozen_string_literal: true

# == Schema Information
#
# Table name: user_accounts
#
#  id                 :bigint           not null, primary key
#  profiles           :integer          default([]), not null, is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint           not null, indexed
#  actualizado_por_id :bigint           indexed
#  creado_por_id      :bigint           indexed
#  user_id            :bigint           not null, indexed
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (creado_por_id => users.id)
#  fk_rails_...  (user_id => users.id)
#

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
end
