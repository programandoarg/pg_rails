require 'rails_helper'

describe Users::ConfirmationsController do
  render_views

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user] # rubocop:disable RSpec/InstanceVariable
  end

  describe '#show sin el token' do
    subject { get :show }

    it do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show con el token' do
    let(:user) { create :user, confirmed_at: nil, confirmation_token: 'bla' }
    subject { get :show, params: { confirmation_token: 'bla' } }

    it do
      subject
      expect(response).to have_http_status(:ok)
    end

    it do
      expect { subject }.to change { user.reload.confirmed_at }.from(nil).to(be_present)
    end
  end
end
