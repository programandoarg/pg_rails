require 'rails_helper'

TYPES = %i[error warn info].freeze

describe PgEngine::PgLogger do
  describe '#pg_err' do
    before do
      TYPES.each do |type|
        allow(Rails.logger).to receive(type)
        allow(Rollbar).to receive(type)
      end
    end

    context 'con exception' do
      subject { pg_err(StandardError.new('bla')) }

      it do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end

  describe '#pg_warn' do
    before do
      TYPES.each do |type|
        allow(Rails.logger).to receive(type)
        allow(Rollbar).to receive(type)
      end
    end

    shared_examples 'logger' do |type|
      it do
        expect(Rails.logger).to have_received(type).twice
      end

      it do
        expect(Rollbar).to have_received(type).once
      end
    end

    TYPES.each do |type|
      context "con type #{type}" do
        before { pg_warn('bla', type) }

        it_behaves_like 'logger', type
      end
    end

    context 'con exception' do
      before { pg_warn(StandardError.new('bla')) }

      it_behaves_like 'logger', :error
    end
  end
  describe '#pg_log' do
    before do
      TYPES.each do |type|
        allow(Rails.logger).to receive(type)
        allow(Rollbar).to receive(type)
      end
    end

    shared_examples 'logger' do |type|
      it do
        expect(Rails.logger).to have_received(type).twice
      end

      it do
        expect(Rollbar).to have_received(type).once
      end
    end

    TYPES.each do |type|
      context "con type #{type}" do
        before { pg_warn('bla', type) }

        it_behaves_like 'logger', type
      end
    end

    context 'con exception' do
      before { pg_warn(StandardError.new('bla')) }

      it_behaves_like 'logger', :error
    end
  end
end
