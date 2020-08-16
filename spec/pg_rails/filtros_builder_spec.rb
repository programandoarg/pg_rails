require 'rails_helper'

describe PgRails::FiltrosBuilder do
  let(:clase) { PgRails::FiltrosBuilder }
  let(:controller) { double() }
  before do
    allow(controller).to receive(:params) { { nombre: 'nombre'} }
    create_list :cosa, 4
    create :cosa, nombre: 'nombre'
  end

  it do
    @filtros = PgRails::FiltrosBuilder.new(controller, Cosa, [:nombre])
    scope = Cosa.all
    scope = @filtros.filtrar(scope)
    expect(scope.count).to eq 1
  end
end
