# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe Cosa, type: :model do
  let(:cosa) { create(:cosa) }

  it 'se persiste' do
    expect(cosa).to be_persisted
  end
end
