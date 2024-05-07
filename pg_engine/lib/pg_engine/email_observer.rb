# frozen_string_literal: true

module PgEngine
  class EmailObserver
    def self.delivered_email(message)
      # content = get_content(message)
      # subject = message.subject

      # message.to puede ser un string o un array de strings
      # to = [message.to].flatten.join(', ')

      message_id = message.message_id
      mailer = message.delivery_handler.to_s
      status = get_status(message)
      content_eml = message.encoded
      if message['email'].present?
        # El objeto Email ya estaba creado. Agarro ese objeto y le actualizo las cosas
        email = message['email'].unparsed_value

        email.update_columns(message_id:, mailer:, status:, content_eml:)
      else
        # FIXME:
        # pg_warn 'El mail no tenía objeto Email asociado, se creó uno on the fly.', :warn
        # # No hay objeto Email, entonces le creo uno para que quede logueado.
        # # TODO: el content puede ser TXT
        # Email.create!(message_id: message.message_id, body_html: message.encoded, subject: subject, recipient: recipient,
        #               date: DateTime.now, mailer: message.delivery_handler.to_s, associated: associated(message),
        #               status: get_status(message), observations: get_observations(message))
      end
    end

    def self.get_html_or_text(message)
      message.body.parts.find { |p| p.content_type.match(/multipart/).present? }
      part = message.body.parts.find { |p| p.content_type.match(/html/).present? }
      part = message.body.parts.find { |p| p.content_type.match(/text/).present? } if part.nil?
      part = message if part.nil?
      part.body.raw_source
    end

    def self.associated(message)
      return if message['associated'].blank?

      message['associated'].unparsed_value
    end

    def self.get_status(message)
      message.perform_deliveries ? :sent : :blocked
    end

    def self.get_observations(message)
      return if message['observations'].blank?

      message['observations'].unparsed_value
    end

    def self.get_content(message)
      multipart = message.body.parts.find { |p| p.content_type.match(/multipart/).present? }
      part = multipart.presence || message
      get_html_or_text(part)
    rescue StandardError => e
      pg_err e
      ''
    end
  end
end
