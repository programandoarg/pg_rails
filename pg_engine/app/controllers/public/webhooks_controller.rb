module Public
  class WebhooksController < PublicController
    skip_before_action :verify_authenticity_token

    def mailgun
      # FIXME: verify signature
      # params['signature']['timestamp']
      if PgEngine::Mailgun::LogSync.digest(params['event-data'])
        head :ok
      else
        head :not_acceptable
      end
    end
  end
end
