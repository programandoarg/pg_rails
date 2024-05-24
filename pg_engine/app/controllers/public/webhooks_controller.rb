module Public
  class WebhooksController < PublicController
    skip_before_action :verify_authenticity_token

    before_action :verify_signagure, only: :mailgun

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
        # Si por algún motivo no se guarda el log, mando internal server error
        # para que mailgun reintente luego
        # Para que no intente más hay que mandar un :not_acceptable (406)
        # https://documentation.mailgun.com/docs/mailgun/user-manual/tracking-messages/#webhooks
        pg_warn 'webhook internal server error', params
        head :internal_server_error
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
      if (Time.at(timestamp.to_i) - Time.now).abs > 1.hour
        pg_warn 'Mailgun Webhook: refusing due to timestamp too far'
        head :ok

        false
      else
        true
      end
    end

    def verify_signagure
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
