# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  it 'se persiste' do
    expect(user).to be_persisted
  end

  it do
    expect(user.current_account).to be_present
  end

  context 'si es orphan' do
    let(:user) { create(:user, orphan: true) }

    it do
      expect(user.accounts).to be_empty
    end

    it do
      expect { user.current_account }.to raise_error(User::Error)
    end
  end

  context 'Si falla la creación de cuenta, que rollbackee la transaction de create user' do
    subject do
      build(:user)
    end

    before do
      allow_any_instance_of(Account).to receive(:save).and_return(false)
      allow_any_instance_of(UserAccount).to receive(:save).and_return(false)
    end

    it do
      expect { subject.save }.not_to change(described_class, :count)
    end

    it do
      subject.save
      expect(subject).not_to be_persisted
    end
  end
end
