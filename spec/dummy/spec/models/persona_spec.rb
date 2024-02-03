# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe Persona do
  let(:persona) { create(:persona) }

  it 'se persiste' do
    expect(persona).to be_persisted
  end
end
