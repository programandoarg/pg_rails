require 'rails_helper'

describe PgEngine::PgLogger do

  describe '#pg_warn' do
    [:error, :warn, :info].each do |type|
      context "con type #{type}" do
        subject { pg_warn('bla', type) }

        it do
          expect(Rails.logger).to receive(type).exactly(2).times
          expect(Rollbar).to receive(type).exactly(1).times
          subject
        end
      end
    end

    context "con exception" do
      subject { pg_warn(StandardError.new('bla')) }

      it do
        expect(Rails.logger).to receive(:error).exactly(2).times
        expect(Rollbar).to receive(:error).exactly(1).times
        subject
      end
    end
  end
end
