require 'rails_helper'
require 'fileutils'

fdescribe PgEngine::Mailgun::LogSync, vcr: { cassette_name: 'mailgun/log_sync_download',
                                            match_requests_on: %i[method host] } do
  let(:instancia) { described_class }

  before do
    FileUtils.rm_r(instancia.base_dir) if File.exists? instancia.base_dir
  end

  describe '#download' do
    subject do
      instancia.download
    end

    let!(:email) { create :email, message_id: '66393f1bc7d4_47a5108ec1628f@notebook.mail' }

    it do
      expect { subject }.to (change { email.email_logs.count }.from(0).to(3))
                                  .and(change(EmailLog, :count).to(8))
    end
  end

  describe '#digest' do
    subject do
      instancia.digest(JSON.parse(log_data))
    end

    let(:log_data) do
      <<~JSON
        {
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
      JSON
    end

    it do
      expect { subject }.to change(EmailLog, :count).by(1)
    end

    it do
      expect(subject).to have_attributes(
        log_id: 'log_2',
        event: 'delivered',
        log_level: 'info',
        severity: 'temporary',
        timestamp: 1715014542,
        message_id: 'msgid@fakeapp2024.mail'
      )
    end

    context 'cuando se asocia a un email' do
      let!(:email) { create :email, message_id: 'msgid@fakeapp2024.mail' }

      it do
        expect(subject.email).to eq email
      end

      it 'changes email status' do
        expect { subject }.to change { email.reload.status }.to 'delivered'
      end
    end

    context 'cuando hay errores' do
      subject do
        instancia.digest({})
      end

      it do
        expect { subject }.not_to change(EmailLog, :count)
      end
    end
  end
end
