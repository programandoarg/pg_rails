module Public
  class WebhooksController < PublicController
    skip_before_action :verify_authenticity_token

    before_action only: :mailgun, :verify_signagure

    def mailgun
      if PgEngine::Mailgun::LogSync.digest(params['event-data'])
        head :ok
      else
        # Mailgun will retry later
        # Para que no intente más hay que mandar un :not_acceptable (406)
        # https://documentation.mailgun.com/docs/mailgun/user-manual/tracking-messages/#webhooks
        head :internal_server_error
      end
    end

    private

    def verify_signagure
      timestamp = params['signature']['timestamp']
      token = params['signature']['token']
      signature = params['signature']['signature']
      hexdigest = encode(timestamp + token)
      if hexdigest != signature
        pg_warn 'refusing invalid signed mailgun webhook request'
        head :ok
      end
      # FIXME: refuse used tokens
      # FIXME: check timestamp not too far
    end

    def encode(data)
      webhook_secret_key = Rails.application.credentials.dig(:mailgun, :webhook_secret_key)
      OpenSSL::HMAC.hexdigest('sha256', webhook_secret_key, data)
    end
  end
end
