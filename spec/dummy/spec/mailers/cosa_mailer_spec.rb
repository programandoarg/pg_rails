require 'rails_helper'

RSpec.describe CosaMailer do
  describe 'cosa_sin_email_object' do
    subject { mail.deliver }

    let(:should_raise_error) { nil }
    let(:to) { 'fake@fake.com' }

    let!(:mail) do
      described_class.with(should_raise_error:).cosa_sin_email_object(to)
    end

    it 'renders the body' do
      subject

      expect(mail.body.encoded).to include 'Sin email object'
    end

    context 'cuando falla el observer' do
      before do
        allow_any_instance_of(Email).to receive(:encoded_eml).and_raise(StandardError)
      end

      it 'observed' do
        expect { subject }.to change(Email, :count).by(1)
      end
    end

    context 'cuando falla el mailer' do
      let(:should_raise_error) { true }

      it 'no se crea ningún email' do
        # Estaría bueno que quede un registro, igual
        subject

        expect(Email.count).to eq 0
      end
    end

    context 'cuando el "to" está vacío' do
      let(:to) { nil }

      it 'tira error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'cosa' do
    let(:cosa) { create :cosa }
    let(:should_raise_error) { nil }
    let!(:mail) do
      described_class.with(cosa:, should_raise_error:).cosa
    end

    # it 'renders the headers' do
    #   expect(mail).to have_attributes(subject:, to: [to])
    #     .and(satisfy('have from_name') { |m| m.header['From'].value.include?(from_name) })
    # end

    it 'tiene attachment' do
      expect(mail.attachments.length).to eq 1
    end

    context 'when its delivered' do
      subject { mail.deliver }

      let(:email_object) { mail['email_object'].unparsed_value }

      it 'observed' do
        expect { subject }.to change { email_object.reload.message_id }
          .and(change { email_object.encoded_eml.present? }.from(false).to(true))
      end

      it 'renders the body' do
        subject

        expect(mail.body.encoded).to include(root_url)
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
        let(:should_raise_error) { true }

        it 'marca el mail como no_enviado' do
          subject
          expect(Email.first.status).to eq 'failed'
        end
      end
    end
  end
end
