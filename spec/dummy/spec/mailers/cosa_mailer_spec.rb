require 'rails_helper'

RSpec.describe CosaMailer do
  describe 'cosa' do
    let(:cosa) { create :cosa }
    let(:raise_error) { nil }
    let!(:mail) do
      described_class.with(cosa:, raise_error:).cosa
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

    context 'when its delivered' do
      subject { mail.deliver }

      let(:email_object) { mail['email'].unparsed_value }

      it 'observed' do
        expect { subject }.to change { email_object.reload.message_id }
          .and(change { email_object.encoded_eml.present? }.from(false).to(true))
      end

      context 'cuando falla el observer' do
        before do
          allow_any_instance_of(Email).to receive(:encoded_eml).and_raise(StandardError)
        end

        it 'observed' do
          expect { subject }.to(change { email_object.reload.message_id })
        end
      end

      context 'cuando falla el mailer' do
        let(:raise_error) { true }

        it 'marca el mail como no_enviado' do
          subject
          expect(Email.first.status).to eq 'failed'
        end
      end
    end
  end
end
