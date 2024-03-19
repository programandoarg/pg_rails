require 'rails_helper'

describe PgEngine::Resource do
  let(:instancia) { Admin::CategoriaDeCosasController.new }

  describe '#buscar_instancia' do
    let!(:categoria_de_cosa) { create :categoria_de_cosa }
    let(:request) { double }
    before do
      instancia.set_clase_modelo
      allow(request).to receive(:filtered_parameters).and_return({ id: categoria_de_cosa.to_param })
      allow(request).to receive(:parameters).and_return({ id: categoria_de_cosa.to_param })
      allow(instancia).to receive(:request).and_return(request)
    end

    subject do
      instancia.send(:buscar_instancia)
    end
    it do
      expect(CategoriaDeCosa).to receive(:find_by_hashid!)
      subject
    end

    it do
      expect(subject).to eq categoria_de_cosa
    end
  end

  describe '#do_sort' do
    let!(:categoria_de_cosa1) { create :categoria_de_cosa, nombre: 'Z' }
    let!(:categoria_de_cosa2) { create :categoria_de_cosa, nombre: 'a' }
    let(:scope) { CategoriaDeCosa.all }
    let(:param) { :nombre }
    let(:direction) { :desc }

    subject do
      instancia.send(:do_sort, scope, param, direction)
    end

    context 'asc' do
      let(:direction) { :asc }

      it do
        expect(subject.to_a).to eq [categoria_de_cosa2, categoria_de_cosa1]
      end
    end

    context 'desc' do
      let(:direction) { :desc }

      it do
        expect(subject.to_a).to eq [categoria_de_cosa1, categoria_de_cosa2]
      end
    end

    context 'cuando no existe el param' do
      let(:param) { :inexistente }

      it do
        expect(subject.to_a).to eq [categoria_de_cosa1, categoria_de_cosa2]
      end
    end
  end
end
