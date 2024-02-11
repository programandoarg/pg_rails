# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  it 'se persiste' do
    expect(user).to be_persisted
  end
end
