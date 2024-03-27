require 'rails_helper'

TYPES = %i[error warn info debug].freeze

describe PgEngine::PgLogger do
  describe '#pg_err' do
    before do
      TYPES.each do |type|
        allow(Rails.logger).to receive(type)
        allow(Rollbar).to receive(type)
      end
    end

    around do |example|
      described_class.raise_errors = false
      example.run
      described_class.raise_errors = true
    end

    shared_examples 'logger' do |type|
      it do
        expect(Rails.logger).to have_received(type).twice
      end

      it do
        expect(Rollbar).to have_received(type).once
      end
    end

    context 'con string' do
      before { pg_err('bla') }

      it_behaves_like 'logger', :error
    end

    context 'con exception' do
      before do
        raise StandardError, 'bla'
      rescue StandardError => e
        pg_err(e)
      end

      it_behaves_like 'logger', :error
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
      before do
        raise StandardError, 'bla'
      rescue StandardError => e
        pg_warn(e)
      end

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
        before { pg_log('bla', type) }

        it_behaves_like 'logger', type
      end
    end
  end
end
