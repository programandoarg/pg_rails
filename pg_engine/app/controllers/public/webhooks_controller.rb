module Public
  class WebhooksController < PublicController
    skip_before_action :verify_authenticity_token

    before_action :verify_signature, only: :mailgun

    rescue_from StandardError do
      pg_err 'webhook internal server error', request.body.read
      head :internal_server_error
    end

    rescue_from ActionDispatch::Http::Parameters::ParseError do
      pg_warn 'webhook parser error', request.body.read
      head :bad_request
    end

    def mailgun
      if PgEngine::Mailgun::LogSync.digest(params['event-data'])
        head :ok
      else
        # Si no se guardó el log es porque ya existía un log con ese ID
        # Mando :not_acceptable (406) para que Mailgun no vuelva a intentar
        # https://documentation.mailgun.com/docs/mailgun/user-manual/tracking-messages
        pg_warn 'ya existía un log con ese id, raaaaro', params
        head :not_acceptable
      end
    end

    private

    def used_tokens
      Kredis.unique_list 'mailgun_webhook_used_tokens'
    end

    def not_used_token(token)
      if used_tokens.elements.include?(token)
        pg_warn 'Mailgun Webhook: refusing used token'
        head :ok

        false
      else
        used_tokens << token
        true
      end
    end

    def timestamp_not_too_far(timestamp)
      if (Time.zone.at(timestamp.to_i) - Time.zone.now).abs > 1.hour
        pg_warn 'Mailgun Webhook: refusing due to timestamp too far'
        head :ok

        false
      else
        true
      end
    end

    def verify_signature
      timestamp = params['signature']['timestamp']
      token = params['signature']['token']
      signature = params['signature']['signature']
      hexdigest = encode(timestamp + token)

      return unless not_used_token(token)
      return unless timestamp_not_too_far(timestamp)
      return unless hexdigest != signature

      pg_warn 'Mailgun Webhook: refusing invalid signature'
      head :ok
    end

    def encode(data)
      webhook_secret_key = Rails.application.credentials.dig(:mailgun, :webhook_secret_key)
      OpenSSL::HMAC.hexdigest('sha256', webhook_secret_key, data)
    end
  end
end
