require 'rails_helper'

describe PgEngine::PgLogger do
  describe '#pg_warn' do
    %i[error warn info].each do |type|
      context "con type #{type}" do
        subject { pg_warn('bla', type) }

        it do
          expect(Rails.logger).to receive(type).twice
          expect(Rollbar).to receive(type).once
          subject
        end
      end
    end

    context 'con exception' do
      subject { pg_warn(StandardError.new('bla')) }

      it do
        expect(Rails.logger).to receive(:error).twice
        expect(Rollbar).to receive(:error).once
        subject
      end
    end
  end
end
