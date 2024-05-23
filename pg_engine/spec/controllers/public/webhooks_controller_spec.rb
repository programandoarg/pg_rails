require 'rails_helper'

describe Public::WebhooksController do
  describe '#mailgun' do
    subject do
      post :mailgun, body:, as: :json
    end

    let(:body) do
      <<~JSON
        {
          "signature": {
            "timestamp": "1529006854",
            "token": "a8ce0edb2dd8301dee6c2405235584e45aa91d1e9f979f3de0",
            "signature": "d2271d12299f6592d9d44cd9d250f0704e4674c30d79d07c47a66f95ce71cf55"
          },
          "event-data": {
            "timestamp": 1715014542.2477064,
            "ip": "66.102.8.333",
            "event": "delivered",
            "id": "log_2",
            "severity":"temporary",
            "log-level": "info",
            "message": {
                "headers": { "message-id": "msgid@fakeapp2024.mail" }
            },
            "recipient": "natprobel@fakemail.com"
          }
        }
      JSON
    end

    it do
      subject
      expect(response).to have_http_status(:ok)
    end

    it do
      expect { subject }.to change(EmailLog, :count).by(1)
    end
  end
end
