require 'rails_helper'

describe Users::RegistrationsController do
  render_views

  before do
    # rubocop:disable RSpec/InstanceVariable
    @request.env['devise.mapping'] = Devise.mappings[:user]
    # rubocop:enable RSpec/InstanceVariable
  end

  describe '#new' do
    subject { get :new }

    it do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    subject do
      post :create, params: { user: { nombre:, apellido:, email:, password:, password_confirmation: } }
    end

    let(:nombre) { Faker::Name.first_name }
    let(:apellido) { Faker::Name.last_name }
    let(:email) { Faker::Internet.email }
    let(:password) { '123123' }
    let(:password_confirmation) { password }

    it do
      expect { subject }.to change(User, :count).by(1)
    end

    it do
      subject
      expect(response.body).to include I18n.t('devise.registrations.signed_up_but_unconfirmed')
    end

    context 'cuando no coinciden los passwords' do
      let(:password_confirmation) { 'bla' }

      it do
        subject
        expect(response).not_to be_successful
      end
    end
  end

  describe '#edit' do
    subject { get :edit }

    let(:logger_user) { create :user, :admin }

    before do
      sign_in logger_user
    end

    it do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
