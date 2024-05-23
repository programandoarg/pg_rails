# frozen_string_literal: true

# == Schema Information
#
# Table name: email_logs
#
#  id         :bigint           not null, primary key
#  event      :string
#  log_level  :string
#  severity   :string
#  timestamp  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email_id   :bigint           indexed
#  log_id     :string
#  message_id :string
#
# Foreign Keys
#
#  fk_rails_...  (email_id => emails.id)
#
# generado con pg_rails

class EmailLog < ApplicationRecord
  audited

  belongs_to :email, optional: true

  after_create_commit do
    email.update_status! if email.present?
  end

  def status_for_email
    case event
    when 'accepted'
      'accepted'
    when 'delivered'
      'delivered'
    when 'failed'
      if severity == 'permanent'
        'rejected'
      elsif severity == 'temporary'
        'accepted'
      else
        # :nocov:
        pg_warn 'No se pudo detectar el status de email', self
        nil
        # :nocov:
      end
    when 'opened'
      # No cambia el status
    else
      # :nocov:
      pg_warn 'No se pudo detectar el status de email', self
      nil
      # :nocov:
    end
  end
end
