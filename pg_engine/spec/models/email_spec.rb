# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe Email do
  let(:email) { create(:email, status: :pending) }

  it 'se persiste' do
    expect(email).to be_persisted
  end

  describe 'update_status!' do
    context 'cuando hay accepted y delivered' do
      subject do
        create :email_log, email: email.reload, event: 'accepted'
        create :email_log, email: email.reload, event: 'delivered'
      end

      it do
        expect { subject }.to change { email.reload.status }.to 'delivered'
      end
    end

    context 'cuando hay accepted y fallo temporario' do
      subject do
        create :email_log, email: email.reload, event: 'failed', severity: 'temporary'
        create :email_log, email: email.reload, event: 'accepted'
      end

      it do
        expect { subject }.to change { email.reload.status }.to 'accepted'
      end
    end

    context 'cuando hay accepted y fallo permanente' do
      subject do
        create :email_log, email: email.reload, event: 'accepted'
        create :email_log, email: email.reload, event: 'failed', severity: 'permanent'
      end

      it do
        expect { subject }.to change { email.reload.status }.to 'rejected'
      end
    end
  end
end
