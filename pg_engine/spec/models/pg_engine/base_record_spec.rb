require 'rails_helper'

describe PgEngine::BaseRecord do
  describe '#human_attribute_name' do
    it do
      obj = described_class.human_attribute_name('bla_text')
      expect(obj).to eq described_class.human_attribute_name('bla')
    end

    it do
      obj = described_class.human_attribute_name('bla_f')
      expect(obj).to eq described_class.human_attribute_name('bla')
    end
  end
end
