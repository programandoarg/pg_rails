# frozen_string_literal: true

# == Schema Information
#
# Table name: emails
#
#  id                 :bigint           not null, primary key
#  accepted_at        :datetime
#  associated_type    :string           indexed => [associated_id]
#  body_input         :string
#  delivered_at       :datetime
#  from_address       :string           not null
#  from_name          :string
#  mailer             :string
#  opened_at          :datetime
#  reply_to           :string
#  status             :integer          default("pending"), not null
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

class Email < ApplicationRecord
  include Hashid::Rails
  audited

  attr_accessor :require_body_input

  has_one_attached :encoded_eml

  belongs_to :associated, polymorphic: true, optional: true

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  kredis_unique_list :logs

  # TODO: y el fallido temporario?
  enumerize :status, in: { pending: 0, failed: 1, sent: 2, accepted: 3, delivered: 4, rejected: 5 }, scope: true

  validates :from_address, :to, :status, presence: true

  validate do
    if to.present? && !to.split(/[,;]/).all? { |dest| dest.match(/\A[^@\s]+@[^@\s]+\z/) }
      # TODO!: testear
      errors.add(:to, 'no es válido')
    end
  end

  validates :subject, length: { within: 0..200 }
  validates :from_name, length: { within: 0..80 }
  validates :to, length: { within: 3..200 }

  validates :body_input, length: { minimum: 10 }, if: -> { require_body_input }
  validates :body_input, presence: true, if: -> { require_body_input }

  validates :from_name, :subject, :to,
            format: { with: /\A[^\n<>&]*\z/, message: 'contiene caracteres inválidos' }

  after_initialize do
    self.from_address = ENV.fetch('DEFAULT_MAIL_FROM') if from_address.blank?
  end

  # validates_format_of :subject, with: /\A[[[:alpha:]]\(\)\w\s.,;!¡?¿-]+\z/
end
