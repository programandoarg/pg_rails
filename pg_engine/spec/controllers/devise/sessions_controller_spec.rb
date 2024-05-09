require 'rails_helper'

describe Devise::SessionsController do
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
      post :create, params: { user: { email: user.email, password: } }
    end

    let(:password) { 'cosas1234' }
    let(:confirmed_at) { nil }
    let(:user) { create :user, confirmed_at:, password: }

    it do
      subject
      expect(response.body).to include 'Tu cuenta aún no está confirmada.'
    end

    context 'cuando está confirmado' do
      let(:confirmed_at) { Time.zone.now }

      it do
        expect { subject }.to change(controller, :user_signed_in?).from(false).to(true)
      end
    end
  end
end
