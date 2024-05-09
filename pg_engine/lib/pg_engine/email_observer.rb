# frozen_string_literal: true

module PgEngine
  class EmailObserver
    def self.delivered_email(message) # rubocop:disable Metrics/AbcSize
      message_id = message.message_id
      mailer = message.delivery_handler.to_s
      status = get_status(message)
      if message['email'].present?
        email = message['email'].unparsed_value
        email.update_columns(message_id:, mailer:, status:) # rubocop:disable Rails/SkipsModelValidations
      else
        # FIXME: testear
        pg_warn 'El mail no tenía objeto Email asociado.', :warn
        to = [message.to].flatten.join(', ')
        from = [message.from].flatten.join(', ')
        email = Email.create!(message_id:, subject: message.subject, to:, mailer:, status:, from_address: from,
                              from_name: '')
      end
      email.encoded_eml.attach({ io: StringIO.new(message.encoded), filename: "email-#{email.id}.eml" })
    rescue StandardError => e
      pg_warn e, :error
    end

    def self.get_status(message)
      message.perform_deliveries ? :sent : :blocked
    end
  end
end
