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
end
