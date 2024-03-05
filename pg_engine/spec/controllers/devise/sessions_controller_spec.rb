require 'rails_helper'

describe Devise::SessionsController do
  # let(:user) { create :user, :admin }

  # before { sign_in user }
  before do |variable|
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#new' do
    subject { get :new }

    it do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
