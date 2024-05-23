# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe EmailLog do
  let(:email_log) { create(:email_log) }

  it 'se persiste' do
    expect(email_log).to be_persisted
  end
end
