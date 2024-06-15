require 'rails_helper'

describe PgEngine::Resource do
  let(:instancia) { Admin::CategoriaDeCosasController.new }

  describe '#buscar_instancia cuando no existe el record' do
    subject do
      instancia.send(:buscar_instancia)
    end

    let(:request) { double }

    before do
      allow(request).to receive_messages(filtered_parameters: { id: 321 },
                                         parameters: { id: 321 })
      allow(instancia).to receive(:request).and_return(request)
      instancia.set_clase_modelo
    end

    fit do
      expect(subject).to raise_error(PgEngine::PageNotFoundError)
    end
  end

  describe '#buscar_instancia' do
    subject do
      instancia.send(:buscar_instancia)
    end

    let!(:categoria_de_cosa) { create :categoria_de_cosa }
    let(:request) { double }

    before do
      allow(request).to receive_messages(filtered_parameters: { id: categoria_de_cosa.to_param },
                                         parameters: { id: categoria_de_cosa.to_param })
      allow(instancia).to receive(:request).and_return(request)
      instancia.set_clase_modelo
    end

    it do
      allow(CategoriaDeCosa).to receive(:find_by_hashid!)
      subject
      expect(CategoriaDeCosa).to have_received(:find_by_hashid!)
    end

    it do
      expect(subject).to eq categoria_de_cosa
    end
  end

  describe '#do_sort' do
    subject do
      instancia.send(:do_sort, scope, param, direction)
    end

    let!(:cosa_ult) { create :cosa, nombre: 'Z' }
    let!(:cosa_pri) { create :cosa, nombre: 'a' }
    let(:scope) { Cosa.all }
    let(:param) { :nombre }
    let(:direction) { :desc }

    context 'asc' do
      let(:direction) { :asc }

      it do
        expect(subject.to_a).to eq [cosa_pri, cosa_ult]
      end
    end

    context 'desc' do
      let(:direction) { :desc }

      it do
        expect(subject.to_a).to eq [cosa_ult, cosa_pri]
      end
    end

    context 'cuando no existe el param' do
      let(:param) { :inexistente }

      it do
        expect(subject.to_a).to eq [cosa_ult, cosa_pri]
      end
    end

    context 'cuando ordeno por categoria' do
      let(:param) { :categoria_de_cosa }

      before do
        cosa_pri.categoria_de_cosa.update_column(:nombre, 'a')
        cosa_ult.categoria_de_cosa.update_column(:nombre, 'z')
      end

      context 'si es asc' do
        let(:direction) { :asc }

        it do
          expect(subject.to_a).to eq [cosa_pri, cosa_ult]
        end
      end

      context 'si es desc' do
        let(:direction) { :desc }

        it do
          expect(subject.to_a).to eq [cosa_ult, cosa_pri]
        end
      end
    end
  end
end
