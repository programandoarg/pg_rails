# generado con pg_rails

require 'rails_helper'

RSpec.describe CategoriaDeCosa, type: :model do
  let(:categoria_de_cosa) { create(:categoria_de_cosa) }

  it 'se persiste' do
    expect(categoria_de_cosa).to be_persisted
  end
end
