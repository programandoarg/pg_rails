# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                 :bigint           not null, primary key
#  discarded_at       :datetime
#  hashid             :string
#  nombre             :string           not null
#  plan               :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  actualizado_por_id :bigint
#  creado_por_id      :bigint
#
# Indexes
#
#  index_accounts_on_actualizado_por_id  (actualizado_por_id)
#  index_accounts_on_creado_por_id       (creado_por_id)
#
# Foreign Keys
#
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (creado_por_id => users.id)
#
# generado con pg_rails

class Account < ApplicationRecord
  audited
  include Discard::Model

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  enumerize :plan, in: { completar: 0, los: 1, valores: 2 }

  validates :plan, :nombre, presence: true
end
