# frozen_string_literal: true

module PgEngine
  class EmailObserver
    def self.delivered_email(message)
      message_id = message.message_id
      mailer = message.delivery_handler.to_s
      status = get_status(message)

      if message['email'].present?
        email = message['email'].unparsed_value
        email.update_columns(message_id:, mailer:, status:) # rubocop:disable Rails/SkipsModelValidations
        email.encoded_eml.attach({ io: StringIO.new(message.encoded), filename: "email-#{email.id}.eml" })
      else
        pg_warn 'El mail no tenía objeto Email asociado.', :warn
        # FIX: el content puede ser TXT
        # Email.create!(message_id: message.message_id, body_html: message.encoded,
        # subject: subject, recipient: recipient,
        #               date: DateTime.now, mailer: message.delivery_handler.to_s, associated: associated(message),
        #               status: get_status(message), observations: get_observations(message))
      end
    rescue StandardError => e
      pg_warn e, :error
    end

    def self.get_status(message)
      message.perform_deliveries ? :sent : :blocked
    end
  end
end
