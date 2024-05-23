require 'rails_helper'
require 'fileutils'

describe PgEngine::Mailgun::LogSync, vcr: { cassette_name: 'mailgun/log_sync_download',
                                            match_requests_on: %i[method host] } do
  let(:instancia) { described_class }

  before do
    FileUtils.rm_r(instancia.base_dir) if File.exists? instancia.base_dir
  end
  after do
    # FileUtils.rm_r(instancia.base_dir)
  end

  describe '#download' do
    subject do
      instancia.download
    end

    let!(:email) { create :email, message_id: '66393f1bc7d4_47a5108ec1628f@notebook.mail' }

    it do
      expect { subject }.to change { email.logs.to_a.length }.from(0).to(3)
    end
  end

  # describe '#digest_all' do
  #   subject do
  #     instancia.digest_all
  #   end

  #   before do
  #     from = PgEngine::Engine.root.join('spec/fixtures/mailgun_inbox')
  #     to = instancia.inbox_dir
  #     FileUtils.mkdir_p(instancia.base_dir)
  #     FileUtils.cp_r from, to
  #   end

  #   fit do
  #     expect { subject }.to change { Dir["#{instancia.inbox_dir}/*.json"].count }.to(0)
  #   end
  # end
end
