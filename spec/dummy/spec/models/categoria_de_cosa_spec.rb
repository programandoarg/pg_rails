# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe CategoriaDeCosa do
  let(:categoria_de_cosa) { create(:categoria_de_cosa) }

  it 'se persiste' do
    expect(categoria_de_cosa).to be_persisted
  end

  it 'usa una subclase de BaseRecordDecorator' do
    expect(categoria_de_cosa.decorate.class).to be < PgEngine::BaseRecordDecorator
  end
end
