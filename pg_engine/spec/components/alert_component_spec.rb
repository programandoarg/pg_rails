# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlertComponent, type: :component do
  subject do
    render_inline(alert).to_html
  end

  let(:type) { 'notice' }

  let(:toast) { true }
  let(:dismissible) { true }
  let(:content) { 'pasaron cosas' }

  let(:alert) do
    described_class.new(type:, toast:, dismissible:).with_content(content)
  end

  %w[critical alert notice warning success].each do |flash_type|
    context "cuando el type es #{flash_type}" do
      let(:type) { flash_type }

      it do
        expect(subject).to have_text 'pasaron cosas'
      end
    end
  end

  context 'cuando el type no es válido' do
    let(:type) { %w[info danger].sample }

    it do
      expect { subject }.to raise_error(PgEngine::Error)
    end
  end
end
