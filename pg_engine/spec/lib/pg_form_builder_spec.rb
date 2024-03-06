require 'rails_helper'

describe PgFormBuilder do
  let(:categoria) { create :categoria_de_cosa }
  let(:template) { double }
  let(:instancia) { described_class.new('bla', categoria, template, {}) }

  before { create_list :cosa, 2, categoria_de_cosa: categoria }

  describe '#mensaje' do
    subject { instancia.mensaje }

    context 'cuando solo tiene errores de presencia' do
      before do
        categoria.nombre = nil
        categoria.validate
      end

      it { expect(subject).to eq 'Por favor, revisá los campos obligatorios:' }
    end

    context 'cuando solo tiene errores de presencia en nested' do
      before do
        categoria.reload
        categoria.cosas[0].nombre = nil
        categoria.validate
      end

      it { expect(subject).to eq 'Por favor, revisá los campos obligatorios:' }
    end
  end

  describe '#default_prefix' do
    context 'cuando el atributo es masculino' do
      subject { instancia.default_prefix(:nombre) }

      it { expect(subject).to eq 'El nombre' }
    end

    context 'cuando el atributo es femenino' do
      subject { instancia.default_prefix(:fecha) }

      it { expect(subject).to eq 'La fecha' }
    end
  end
end
