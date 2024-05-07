require 'rails_helper'
require 'fileutils'

describe PgEngine::Mailgun::LogSync do
  let(:instancia) { described_class }

  describe '#download',
           vcr: { cassette_name: 'mailgun/log_sync_download',
                  match_requests_on: %i[method host] } do
    subject do
      instancia.download
      instancia.sync_redis
    end

    after do
      Dir["#{instancia.dir}/*.json"].each { |file| File.delete(file) }
    end

    let!(:email) { create :email, message_id: '66393f1bc7d4_47a5108ec1628f@notebook.mail' }

    it do
      expect { subject }.to change { email.logs.to_a.length }.from(0).to(3)
    end
  end
end
