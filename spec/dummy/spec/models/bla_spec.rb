# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe Bla do
  let(:bla) { create(:bla) }

  it 'se persiste' do
    expect(bla).to be_persisted
  end
end
