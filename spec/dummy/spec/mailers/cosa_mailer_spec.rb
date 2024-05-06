require 'rails_helper'

RSpec.describe CosaMailer do
  describe 'cosa' do
    let(:cosa) { create :cosa }
    let(:email) { create :email }

    let(:mail) do
      described_class.with(email:, cosa:).cosa
    end

    # it 'renders the headers' do
    #   expect(mail).to have_attributes(subject:, to: [to])
    #     .and(satisfy('have from_name') { |m| m.header['From'].value.include?(from_name) })
    # end

    # it 'renders the body' do
    #   expect(mail.body.encoded).to match(body)
    # end

    it 'tiene attachment' do
      expect(mail.attachments.length).to eq 2
    end
  end
end
