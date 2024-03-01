require 'rails_helper'

describe PgEngine::BaseRecord do
  describe '#human_attribute_name' do
    subject do
      described_class.human_attribute_name('bla_text')
    end

    it do
      expect(subject).to eq described_class.human_attribute_name('bla')
    end
  end
end
