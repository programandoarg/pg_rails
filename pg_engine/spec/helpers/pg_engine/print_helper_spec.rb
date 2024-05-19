require 'rails_helper'

describe PgEngine::PrintHelper do
  describe '#print_cuit' do
    subject { print_cuit(input) }

    context 'cuando es nil' do
      let(:input) { nil }

      it { expect(subject).to be_nil }
    end

    context 'cuando es un cuit válido' do
      let(:input) { 20_351_404_478 }

      it { expect(subject).to eq '20-35140447-8' }
    end

    context 'cuando es un cuit válido mal formateado' do
      let(:input) { '2035140447-8' }

      it { expect(subject).to eq '20-35140447-8' }
    end

    context 'cuando no es un cuit válido' do
      let(:input) { 2035 }

      it { expect(subject).to eq 2035 }
    end
  end

  describe '#print_currency' do
    subject { print_currency(input) }

    context 'cuando es un entero' do
      let(:input) { 191_624 }

      it { expect(subject).to eq '$ 191.624' }
    end

    context 'cuando tiene 1 decimal' do
      let(:input) { 123_456.1 }

      it { expect(subject).to eq '$ 123.456,10' }
    end

    context 'cuando tiene más de 3 decimales' do
      let(:input) { 123_456.164234 }

      it { expect(subject).to eq '$ 123.456,164' }
    end
  end
end
