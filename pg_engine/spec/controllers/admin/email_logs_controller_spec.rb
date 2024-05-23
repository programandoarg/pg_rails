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

RSpec.fdescribe Admin::EmailLogsController do
  render_views
  # This should return the minimal set of attributes required to create a valid
  # EmailLog. As you add validations to EmailLog, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:email_log)
  end

  let(:logged_user) { create :user, :developer }

  before do
    sign_in logged_user if logged_user.present?
  end

  describe 'routing' do
    it 'routes GET index correctly' do
      route = { get: '/a/email_logs' }
      expect(route).to route_to(controller: 'admin/email_logs', action: 'index')
    end
  end

  describe 'GET #index' do
    subject do
      get :index, params: {}
    end

    let!(:email_log) { create :email_log }

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
      email_log = create(:email_log)
      get :show, params: { id: email_log.to_param }
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
      email_log = create(:email_log)
      get :edit, params: { id: email_log.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new EmailLog' do
        expect do
          post :create, params: { email_log: valid_attributes }
        end.to change(EmailLog, :count).by(1)
      end

      it 'redirects to the created email_log' do
        post :create, params: { email_log: valid_attributes }
        expect(response).to redirect_to([:admin, EmailLog.last])
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:email_log)
      end

      it 'redirects to the email_log' do
        email_log = create(:email_log)
        put :update, params: { id: email_log.to_param, email_log: valid_attributes }
        expect(response).to redirect_to([:admin, email_log])
      end
    end
  end

  describe 'DELETE #destroy' do
    subject do
      request.headers['Accept'] = 'text/vnd.turbo-stream.html,text/html'
      delete :destroy, params: { id: email_log.to_param, redirect_to: redirect_url }
    end

    let!(:email_log) { create :email_log }
    let(:redirect_url) { nil }

    it 'destroys the requested email_log' do
      expect { subject }.to change(EmailLog, :count).by(-1)
    end

    it 'quita el elemento de la lista' do
      subject
      expect(response.body).to include('turbo-stream action="remove"')
    end

    context 'si hay redirect_to' do
      let(:redirect_url) { admin_email_logs_url }

      it 'redirects to the email_logs list' do
        subject
        expect(response).to redirect_to(admin_email_logs_url)
      end
    end
  end
end
