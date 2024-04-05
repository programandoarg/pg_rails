require 'rails_helper'

class DummyBaseController < PgEngine::BaseController
  def action_with_redirect
    raise PgEngine::BaseController::Redirect, '/some_path'
  end

  def check_dev_user
    @dev_user_or_env = dev_user_or_env?
    @dev_user = dev_user?
    head :ok
  end
end

Rails.application.routes.draw do
  get :action_with_redirect, to: 'dummy_base#action_with_redirect'
  get :check_dev_user, to: 'dummy_base#check_dev_user'
end

# rubocop:disable RSpec/MultipleExpectations
# rubocop:disable RSpec/FilePath
# rubocop:disable RSpec/SpecFilePathFormat
describe DummyBaseController do
  describe 'PgEngine::BaseController::Redirect' do
    before { get :action_with_redirect }

    it do
      expect(response).to redirect_to '/some_path'
    end
  end

  describe '#dev_user_or_env?' do
    let(:user) { create :user, :developer }

    before do
      sign_in user if user.present?
      get :check_dev_user
    end

    it do
      expect(assigns(:dev_user_or_env)).to be_truthy
      expect(assigns(:dev_user)).to be_truthy
    end

    context 'when not signed in' do
      let(:user) { nil }

      it do
        expect(assigns(:dev_user_or_env)).to be_falsey
        expect(assigns(:dev_user)).to be_falsey
      end
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
# rubocop:enable RSpec/FilePath
# rubocop:enable RSpec/SpecFilePathFormat
