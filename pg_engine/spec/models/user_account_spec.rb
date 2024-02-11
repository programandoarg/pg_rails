# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe UserAccount do
  let(:user_account) { create(:user_account) }

  it 'se persiste' do
    expect(user_account).to be_persisted
  end
end
