require 'rails_helper'

describe Devise::RegistrationsController do
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

  describe '#edit' do

    let(:logger_user) { create :user, :admin }

    before do
      sign_in logger_user
    end

    subject { get :edit }

    it do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
