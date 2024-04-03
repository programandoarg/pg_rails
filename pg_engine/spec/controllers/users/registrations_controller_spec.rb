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
      post :create, params: {
        user: {
          nombre: Faker::Name.first_name,
          apellido: Faker::Name.last_name,
          email: Faker::Internet.email,
          password: '123123',
          password_confirmation: '123123'
        }
      }
    end

    it do
      expect { subject }.to change(User, :count).by(1)
    end

    it do
      subject
      expect(response.body).to include I18n.t('devise.registrations.signed_up_but_unconfirmed')
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
