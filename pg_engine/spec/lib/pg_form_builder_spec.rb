require 'rails_helper'

describe PgFormBuilder do
  let(:categoria) { create :categoria_de_cosa }
  let(:template) do
    klass = Class.new
    klass.include ActionView::Helpers::TagHelper
    klass.new
  end

  let(:instancia) { described_class.new('bla', categoria, template, {}) }

  before { create_list :cosa, 2, categoria_de_cosa: categoria }

  describe '#mensajes_de_error' do
    subject { instancia.mensajes_de_error }

    # expect(subject)
    # it { expect(subject).to eq 'Por favor, revisá los campos obligatorios:' }

    context 'cuando solo tiene errores de presencia' do
      before do
        categoria.nombre = nil
        categoria.validate
      end

      it { expect(subject).to include 'Por favor, revisá los campos obligatorios:' }
      it { expect(subject).to include 'not_base_errors' }
    end

    context 'cuando solo tiene errores de :base' do
      before do
        categoria.validate_base = true
        categoria.validate
      end

      it { expect(subject).to include 'Por favor, revisá los siguientes errores' }
      it { expect(subject).not_to include 'not_base_errors' }
    end
  end

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
