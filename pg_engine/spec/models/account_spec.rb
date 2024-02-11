# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe Account do
  let(:account) { create(:account) }

  it 'se persiste' do
    expect(account).to be_persisted
  end
end
