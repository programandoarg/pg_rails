require 'rails_helper'

class DummyBaseController < PgEngine::BaseController
  def action_with_redirect
    raise PgEngine::BaseController::Redirect, '/some_path'
  end

  def test_not_authorized
    raise Pundit::NotAuthorizedError
  end

  def check_dev_user
    @dev_user_or_env = dev_user_or_env?
    @dev_user = dev_user?
    head :ok
  end
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

  describe 'not_authorized' do
    subject do
      get :test_not_authorized
    end

    let(:user) { create :user }

    before do
      sign_in user
    end

    it do
      subject
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Not authorized'
      expect(controller.user_signed_in?).to be_truthy
    end

    context 'cuando ocurre en el root_path' do

      before do
        allow_any_instance_of(ActionController::TestRequest).to receive(:path).and_return(root_path)
      end

      it do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq 'Not authorized'
        expect(controller.user_signed_in?).to be_falsey
      end
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
