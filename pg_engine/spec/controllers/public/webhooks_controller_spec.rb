require 'rails_helper'

def build_body(id, signature, timestamp)
  <<~JSON
    {
      "signature": {
        "timestamp": "#{timestamp}",
        "token": "6fcc81a280a2458de8c83bf22dde8c71485be1d51333d3427e",
        "signature": "#{signature}"
      },
      "event-data": {
        "timestamp": 1715014542.2477064,
        "ip": "66.102.8.333",
        "event": "delivered",
        "id": "#{id}",
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

describe Public::WebhooksController do
  include ActiveSupport::Testing::TimeHelpers

  around do |example|
    travel_to Time.at(1716564587) do
      example.run
    end
  end

  describe '#mailgun' do
    subject do
      post :mailgun, body:, as: :json
    end

    let(:signature) { 'c524037907046276117758afae8a340e77a43a6e48eb35a9521426e7a3ff675b' }
    let(:id) { 'log_2' }
    let(:timestamp) { '1716564587' }

    let(:body) do
      build_body(id, signature, timestamp)
    end

    it do
      subject
      expect(response).to have_http_status(:ok)
    end

    it do
      expect { subject }.to change(EmailLog, :count).by(1)
    end

    context 'cuando no se puede procesar el log' do
      let(:body) { '{ "este json": "no me sirve" }' }

      it do
        subject
        expect(response).to have_http_status(:internal_server_error)
      end

      fit do
        expect { subject }.to have_errored('internal server error') \
          .and(have_errored('no me sirve'))
      end
    end

    context 'cuando no es un json' do
      let(:body) { 'mal json' }

      it do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      fit do
        expect { subject }.to have_warned('parser error').and(have_warned('mal json'))
      end
    end

    shared_context 'todo bien pero no guarda el log' do
      it 'responds ok' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'no guarda el log ;)' do
        expect { subject }.not_to change(EmailLog, :count)
      end
    end

    context 'si la signature no es válida' do
      let(:signature) { 'no válida' }

      it_behaves_like 'todo bien pero no guarda el log'

      fit do
        expect { subject }.to have_warned('refusing invalid signature')
      end
    end

    context 'cuando ya se usó el token' do
      before do
        post :mailgun, body: build_body(id, signature, timestamp), as: :json
      end

      subject do
        post :mailgun, body: build_body('otro id', signature, timestamp), as: :json
      end

      it_behaves_like 'todo bien pero no guarda el log'

      fit do
        expect { subject }.to have_warned('refusing used token')
      end
    end

    context 'cuando la timestamp está muy lejos' do
      let(:timestamp) { '1111111' }
      let(:signature) { '869c06cea4be27321a6a7c6a8e3d0668bb9c2b5b3de5532f644dba181a157d9a' }

      it_behaves_like 'todo bien pero no guarda el log'

      fit do
        expect { subject }.to have_warned('refusing due to timestamp')
      end
    end
  end
end
