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

  it do
    expect(subject).to include 'pasaron cosas'
  end
end
