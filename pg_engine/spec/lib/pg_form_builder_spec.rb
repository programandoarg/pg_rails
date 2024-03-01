require 'rails_helper'

describe PgFormBuilder do
  let(:categoria) { create :categoria_de_cosa }
  before { create_list :cosa, 2, categoria_de_cosa: categoria}
  let(:template) { double }
  let(:instancia) { described_class.new('bla', categoria, template, {}) }

  describe '#mensaje' do
    subject { instancia.mensaje }

    context 'cuando solo tiene errores de presencia' do
      before do
        categoria.nombre = nil
        categoria.validate
      end

      it { expect(subject).to eq 'Por favor, revisá los campos obligatorios:' }
    end

    context 'cuando solo tiene errores de presencia' do
      before do
        categoria.reload
        categoria.cosas[0].nombre = nil
        categoria.validate
      end

      it { expect(subject).to eq 'Por favor, revisá los campos obligatorios:' }
    end
  end
end
