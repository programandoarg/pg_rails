require 'rails_helper'

describe PgEngine::PgLogger do
  describe '#pg_warn' do
    let(:types) { %i[error warn info] }

    before do
      types.each do |type|
        Rails.logger.stub(type)
        Rollbar.stub(type)
      end
    end

    types.each do |type|
      context "con type #{type}" do
        before { pg_warn('bla', type) }

        it do
          expect(Rails.logger).to have_received(type).twice
        end

        it do
          expect(Rollbar).to have_received(type).once
        end
      end
    end

    context 'con exception' do
      before { pg_warn(StandardError.new('bla')) }

      it do
        expect(Rails.logger).to have_received(:error).twice
      end

      it do
        expect(Rollbar).to have_received(:error).once
      end
    end
  end
end
