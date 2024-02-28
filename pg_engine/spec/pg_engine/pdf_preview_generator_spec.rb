require 'rails_helper'

describe PgEngine::PdfPreviewGenerator do
  let(:pdf_string) { File.read("#{PgEngine::Engine.root}/spec/fixtures/test.pdf") }
  let(:instancia) { described_class.new }

  describe '#run' do
    subject { instancia.run(pdf_string) }

    it { is_expected.to be_a String }
  end
end
