require 'rails_helper'

TYPES = %i[error warn info debug].freeze

describe PgEngine::PgLogger do
  before do
    TYPES.each do |type|
      allow(Rails.logger).to receive(type)
      allow(Rollbar).to receive(type)
    end
  end

  shared_examples 'logger' do |type|
    it do
      expect(Rails.logger).to have_received(type).once
    end

    it do
      expect(Rollbar).to have_received(type).once
    end
  end

  describe '#pg_log' do
    TYPES.each do |type|
      context "con type #{type}" do
        before { pg_log(type, 'bla') }

        it_behaves_like 'logger', type
      end
    end
  end

  describe '#pg_err' do
    before { pg_err('bla') }

    it_behaves_like 'logger', :error
  end

  describe '#pg_debug' do
    before { pg_debug('bla') }

    it_behaves_like 'logger', :debug
  end

  describe '#pg_warn' do
    before { pg_warn('bla') }

    it_behaves_like 'logger', :warn
  end

  describe '#pg_info' do
    before { pg_info('bla') }

    it_behaves_like 'logger', :info
  end
end
