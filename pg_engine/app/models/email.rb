# frozen_string_literal: true

# == Schema Information
#
# Table name: emails
#
#  id                 :bigint           not null, primary key
#  accepted_at        :datetime
#  associated_type    :string           indexed => [associated_id]
#  body_input         :string
#  content_eml        :string
#  delivered_at       :datetime
#  from_address       :string           not null
#  from_name          :string
#  mailer             :string
#  opened_at          :datetime
#  reply_to           :string
#  status             :integer          default(0), not null
#  status_detail      :string
#  subject            :string
#  tags               :string           is an Array
#  to                 :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  actualizado_por_id :bigint           indexed
#  associated_id      :bigint           indexed => [associated_type]
#  creado_por_id      :bigint           indexed
#  message_id         :string
#
# Foreign Keys
#
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (creado_por_id => users.id)
#
# generado con pg_rails

class Email < ApplicationRecord
  audited

  belongs_to :associated, polymorphic: true, optional: true

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  validates :from_address, :to, :status, presence: true
end
