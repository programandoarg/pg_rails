module Public
  class WebhooksController < PublicController
    def mailgun
      # FIXME: verify signature
      # params['signature']['timestamp']
      PgEngine::Mailgun::LogSync.digest(params['event-data'])
      head :ok
    end
  end
end
