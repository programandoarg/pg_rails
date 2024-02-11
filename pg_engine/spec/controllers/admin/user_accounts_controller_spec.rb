# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Admin::UserAccountsController do
  render_views
  let(:user) { create :user }

  let(:account) { create :account }

  # This should return the minimal set of attributes required to create a valid
  # UserAccount. As you add validations to UserAccount, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:user_account).merge(user_id: user.id, account_id: account.id)
  end

  let(:invalid_attributes) do
    {
      user_id: nil
    }
  end

  let(:logged_user) { create :user, :developer }

  before do
    sign_in logged_user if logged_user.present?
  end

  describe 'routing' do
    it 'routes GET index correctly' do
      route = { get: '/a/user_accounts' }
      expect(route).to route_to(controller: 'admin/user_accounts', action: 'index')
    end
  end

  describe 'GET #index' do
    subject do
      get :index, params: {}
    end

    before { create :user_account }

    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      let(:logged_user) { nil }

      it 'redirects to login path' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when se pide el excel' do
      subject do
        get :index, params: {}, format: 'xlsx'
      end

      it 'returns a success response' do
        subject
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      user_account = create(:user_account)
      get :show, params: { id: user_account.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      user_account = create(:user_account)
      get :edit, params: { id: user_account.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new UserAccount' do
        expect do
          post :create, params: { user_account: valid_attributes }
        end.to change(UserAccount, :count).by(1)
      end

      it 'redirects to the created user_account' do
        post :create, params: { user_account: valid_attributes }
        expect(response).to redirect_to(UserAccount.last.decorate.target_object)
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        post :create, params: { user_account: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new template' do
        post :create, params: { user_account: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:user_account)
      end

      it 'updates the requested user_account' do
        user_account = create(:user_account)
        put :update, params: { id: user_account.to_param, user_account: new_attributes }
        user_account.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the user_account' do
        user_account = create(:user_account)
        put :update, params: { id: user_account.to_param, user_account: valid_attributes }
        expect(response).to redirect_to(user_account.decorate.target_object)
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        user_account = create(:user_account)
        put :update, params: { id: user_account.to_param, user_account: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        user_account = create(:user_account)
        put :update, params: { id: user_account.to_param, user_account: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject do
      delete :destroy, params: { id: user_account.to_param }
    end

    let!(:user_account) { create :user_account }

    it 'destroys the requested user_account' do
      expect { subject }.to change(UserAccount, :count).by(-1)
    end

    it 'redirects to the user_accounts list' do
      subject
      expect(response).to redirect_to(admin_user_accounts_url)
    end
  end
end
