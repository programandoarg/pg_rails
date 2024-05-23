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
end
