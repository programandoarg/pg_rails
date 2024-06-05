require 'rails_helper'

describe InternalErrorComponent, type: :component do
  subject do
    render_inline(internal_error).to_html
  end

  let(:internal_error) do
    described_class.new(error_msg:)
  end

  let(:error_msg) { 'internal error' }

  it do
    expect(subject).to have_text(error_msg)
  end
end
