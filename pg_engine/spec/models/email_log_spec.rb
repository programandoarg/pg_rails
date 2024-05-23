# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe EmailLog do
  let(:email_log) { create(:email_log) }

  it 'se persiste' do
    expect(email_log).to be_persisted
  end

  describe 'status_for_email' do
    subject do
      email_log.status_for_email
    end

    let(:email_log) { create(:email_log, event:, severity:) }
    let(:severity) { nil }

    context 'cuando es accepted' do
      let(:event) { 'accepted' }

      it { is_expected.to eq 'accepted' }
    end

    context 'cuando es delivered' do
      let(:event) { 'delivered' }

      it { is_expected.to eq 'delivered' }
    end

    context 'cuando hay un fallo temporario' do
      let(:event) { 'failed' }
      let(:severity) { 'temporary' }

      it { is_expected.to eq 'accepted' }
    end

    context 'cuando hay un fallo permanente' do
      let(:event) { 'failed' }
      let(:severity) { 'permanent' }

      it { is_expected.to eq 'rejected' }
    end
  end
end
