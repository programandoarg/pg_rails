require 'rails_helper'

describe Users::RegistrationsController do
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
