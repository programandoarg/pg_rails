require 'rails_helper'

describe PgRails::FiltrosBuilder do
  let(:clase) { PgRails::FiltrosBuilder }
  let(:user) { create :user }

  before do
    create :cosa, tipo: :completar
    create :cosa, tipo: :los, deleted_at: Time.now
    create :cosa, tipo: :valores, nombre: 'nombre falso'
  end

  describe 'interfaz deprecada' do
    let(:controller) { double() }
    let(:user) { create :user }
    before { allow(controller).to receive(:current_user) { user } }
    before { allow(controller).to receive(:params) { {} } }

    context 'con controller' do
      before { allow(controller).to receive(:params) { { nombre: 'nombre falso'} } }

      it do
        @filtros = PgRails::FiltrosBuilder.new(controller, Cosa, [:nombre])
        scope = Cosa.all
        scope = @filtros.filtrar(scope)
        expect(scope.count).to eq 1
      end
    end

    context 'pasando parametros a mano' do

      it do
        @filtros = PgRails::FiltrosBuilder.new(controller, Cosa, [:nombre])
        scope = Cosa.all
        scope = @filtros.filtrar(scope, { nombre: 'nombre falso'})
        expect(scope.count).to eq 1
      end
    end
  end

  it do
    @filtros = PgRails::FiltrosBuilder.new(clase_modelo: Cosa, filtrar_por: { nombre: 'nombre falso' })
    expect(@filtros.filtrar.count).to eq 1
  end

  describe 'with or without deleted' do
    it do
      @filtros = PgRails::FiltrosBuilder.new(clase_modelo: Cosa)
      expect(@filtros.filtrar.count).to eq 2
    end

    it do
      @filtros = PgRails::FiltrosBuilder.new(clase_modelo: Cosa, with_deleted: true)
      expect(@filtros.filtrar.count).to eq 3
    end
  end

  it 'policy' do
    allow(user).to receive(:admin?) { false }
    @filtros = PgRails::FiltrosBuilder.new(clase_modelo: Cosa, user: user)
    expect(@filtros.filtrar.count).to eq 1
  end

  it 'opciones' do
    cosa = create :cosa, nombre: 'lambda'
    @filtros = PgRails::FiltrosBuilder.new(clase_modelo: Cosa, user: user, filtrar_por: { campo_false: true })
    @filtros.opciones(:campo_false, query: lambda { |scope, value| scope.where(nombre: 'lambda') })
    @filtros.opciones(:campo_false, tipo: :select)
    expect(@filtros.filtrar).to match_array [cosa]
  end
end
