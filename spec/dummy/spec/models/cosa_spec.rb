# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe Cosa do
  let(:cosa) { create(:cosa) }

  it 'se persiste' do
    expect(cosa).to be_persisted
  end

  it 'usa el BaseRecordDecorator' do
    expect(cosa.decorate.class).to eq PgEngine::BaseRecordDecorator
  end
end
