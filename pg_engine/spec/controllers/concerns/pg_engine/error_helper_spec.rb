require 'rails_helper'

describe PgEngine::ErrorHelper do
  let(:dummy) { Class.new { include PgEngine::ErrorHelper }.new }

  describe '#error_message_for' do
    subject do
      categoria.validate
      dummy.error_message_for(categoria, associations: [:cosas])
    end

    let!(:categoria) { create :categoria_de_cosa }

    before { create_list :cosa, 2, categoria_de_cosa: categoria }

    it do
      expect(subject).to be_nil
    end

    context 'cuando solo tiene errores de presencia' do
      before do
        categoria.nombre = nil
      end

      it do
        expect(subject).to eq :only_presence_errors
      end
    end

    context 'cuando solo tiene otros errores' do
      before do
        categoria.validate_aux = true
      end

      it do
        expect(subject).to eq :not_presence_errors
      end
    end

    context 'cuando tiene multiples errores' do
      before do
        categoria.validate_aux = true
        categoria.nombre = nil
      end

      it do
        expect(subject).to eq :multiple_error_types
      end
    end

    context 'cuando tiene errores anidados' do
      before do
        categoria.cosas[0].nombre = nil
      end

      it do
        expect(subject).to eq :only_presence_errors
      end
    end
  end
end
