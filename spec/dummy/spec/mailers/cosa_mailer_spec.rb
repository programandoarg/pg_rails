require 'rails_helper'

RSpec.describe CosaMailer do
  describe 'cosa' do
    let(:cosa) { create :cosa }

    let!(:mail) do
      described_class.with(cosa:).cosa
    end

    # it 'renders the headers' do
    #   expect(mail).to have_attributes(subject:, to: [to])
    #     .and(satisfy('have from_name') { |m| m.header['From'].value.include?(from_name) })
    # end

    # it 'renders the body' do
    #   expect(mail.body.encoded).to match(body)
    # end

    it 'tiene attachment' do
      expect(mail.attachments.length).to eq 1
    end

    context do
      subject { mail.deliver }

      let(:email_object) { mail['email'].unparsed_value }

      it 'observed' do
        expect { subject }.to change { email_object.reload.message_id }
      end
    end
  end
end
