require 'rails_helper'

describe EmailDecorator do
  let(:email) { create :email, status: }
  let(:decorator) { email.decorate }

  describe '#status_f' do
    subject { decorator.status_f }

    context 'cuando está entregado' do
      let(:status) { :delivered }

      it 'tiene badge success' do
        expect(subject).to include('text-bg-success').and(include('Entregado'))
      end
    end
  end
end
