# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe MensajeContacto do
  let(:mensaje_contacto) { create(:mensaje_contacto) }

  it 'se persiste' do
    expect(mensaje_contacto).to be_persisted
  end
end
