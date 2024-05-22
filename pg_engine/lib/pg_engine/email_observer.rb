# frozen_string_literal: true

module PgEngine
  class EmailObserver
    def self.delivered_email(message) # rubocop:disable Metrics/AbcSize
      message_id = message.message_id
      mailer = message.delivery_handler.to_s
      status = get_status(message)
      if message['email_object'].present?
        email_object = message['email_object'].unparsed_value
        email_object.update_columns(message_id:, mailer:, status:) # rubocop:disable Rails/SkipsModelValidations
      else
        to = [message.to].flatten.join(', ')
        from = [message.from].flatten.join(', ')
        email_object = Email.create!(message_id:, subject: message.subject, to:, mailer:, status:, from_address: from,
                              from_name: '')
      end
      email_object.encoded_eml.attach({ io: StringIO.new(message.encoded), filename: "email-#{email_object.id}.eml" })
    rescue StandardError => e
      pg_err e
    end

    def self.get_status(message)
      message.perform_deliveries ? :sent : :blocked
    end
  end
end
