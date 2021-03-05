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

<% module_namespacing do -%>
RSpec.describe <%= controller_class_name %>Controller, <%= type_metatag(:controller) %> do
<% if mountable_engine? -%>
  routes { <%= mountable_engine? %>::Engine.routes }

<% end -%>
<% referencias_requeridas.each do |atributo| -%>
  let(:<%= atributo.name %>) { create :<%= atributo.name %> }

<% end -%>
  # This should return the minimal set of attributes required to create a valid
  # <%= class_name %>. As you add validations to <%= class_name %>, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:<%= nombre_tabla_completo_singular %>)<%= merge_referencias %>
  end

<% if attributes.any? { |at| at.required? } -%>
  let(:invalid_attributes) do
    {
<% attributes.select { |at| at.required? }.each do |atributo| -%>
      <%= "#{atributo.name}: nil,"  %>
<% end -%>
    }
  end
<% end -%>

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # <%= controller_class_name %>Controller. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { create :user, :admin }

  before do
    sign_in user
  end

<% unless options[:singleton] -%>
  describe 'GET #index' do
    subject do
<% if Rails::VERSION::STRING < '5.0' -%>
      get :index, {}, valid_session
<% else -%>
      get :index, params: {}, session: valid_session
<% end -%>
    end

    let!(:<%= ns_file_name %>) { create :<%= ns_file_name %> }

    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end
<% if options[:discard] -%>

    context 'si está descartado' do
      before { <%= ns_file_name %>.discard! }

      it do
        subject
        expect(assigns(:<%= table_name %>)).to be_empty
      end
    end
<% end -%>
  end

<% end -%>
  describe 'GET #show' do
    it 'returns a success response' do
      <%= file_name %> = create(:<%= ns_file_name %>)
<% if Rails::VERSION::STRING < '5.0' -%>
      get :show, { id: <%= file_name %>.to_param }, valid_session
<% else -%>
      get :show, params: { id: <%= file_name %>.to_param }, session: valid_session
<% end -%>
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
<% if Rails::VERSION::STRING < '5.0' -%>
      get :new, {}, valid_session
<% else -%>
      get :new, params: {}, session: valid_session
<% end -%>
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      <%= file_name %> = create(:<%= ns_file_name %>)
<% if Rails::VERSION::STRING < '5.0' -%>
      get :edit, { id: <%= file_name %>.to_param }, valid_session
<% else -%>
      get :edit, params: { id: <%= file_name %>.to_param }, session: valid_session
<% end -%>
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new <%= class_name %>' do
        expect do
<% if Rails::VERSION::STRING < '5.0' -%>
          post :create, { <%= ns_file_name %>: valid_attributes }, valid_session
<% else -%>
          post :create, params: { <%= ns_file_name %>: valid_attributes }, session: valid_session
<% end -%>
        end.to change(<%= class_name %>, :count).by(1)
      end

      it 'redirects to the created <%= ns_file_name %>' do
<% if Rails::VERSION::STRING < '5.0' -%>
        post :create, { <%= ns_file_name %>: valid_attributes }, valid_session
<% else -%>
        post :create, params: { <%= ns_file_name %>: valid_attributes }, session: valid_session
<% end -%>
        expect(response).to redirect_to(<%= class_name %>.last)
      end
    end

<% if attributes.any? { |at| at.required? } -%>
    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
<% if Rails::VERSION::STRING < '5.0' -%>
        post :create, { <%= ns_file_name %>: invalid_attributes }, valid_session
<% else -%>
        post :create, params: { <%= ns_file_name %>: invalid_attributes }, session: valid_session
<% end -%>
        expect(response).to be_successful
      end
    end
<% end -%>
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:<%= nombre_tabla_completo_singular %>)
      end

      it 'updates the requested <%= ns_file_name %>' do
        <%= file_name %> = create(:<%= ns_file_name %>)
<% if Rails::VERSION::STRING < '5.0' -%>
        put :update, { id: <%= file_name %>.to_param, <%= ns_file_name %>: new_attributes }, valid_session
<% else -%>
        put :update, params: { id: <%= file_name %>.to_param, <%= ns_file_name %>: new_attributes }, session: valid_session
<% end -%>
        <%= file_name %>.reload
<% atributo = attributes.find { |at| !at.reference? && at.required? } -%>
<% if atributo.present? -%>
        expect(<%= file_name%>.<%= atributo.name %>).to eq new_attributes[:<%= atributo.name %>]
<% else -%>
        skip("Add assertions for updated state")
<% end -%>
      end

      it 'redirects to the <%= ns_file_name %>' do
        <%= file_name %> = create(:<%= ns_file_name %>)
<% if Rails::VERSION::STRING < '5.0' -%>
        put :update, { id: <%= file_name %>.to_param, <%= ns_file_name %>: valid_attributes }, valid_session
<% else -%>
        put :update, params: { id: <%= file_name %>.to_param, <%= ns_file_name %>: valid_attributes }, session: valid_session
<% end -%>
        expect(response).to redirect_to(<%= file_name %>)
      end
    end

<% if attributes.any? { |at| at.required? } -%>
    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "edit" template)' do
        <%= file_name %> = create(:<%= ns_file_name %>)
<% if Rails::VERSION::STRING < '5.0' -%>
        put :update, { id: <%= file_name %>.to_param, <%= ns_file_name %>: invalid_attributes }, valid_session
<% else -%>
        put :update, params: { id: <%= file_name %>.to_param, <%= ns_file_name %>: invalid_attributes }, session: valid_session
<% end -%>
        expect(response).to be_successful
      end
    end
<% end -%>
  end

  describe 'DELETE #destroy' do
    subject do
<% if Rails::VERSION::STRING < '5.0' -%>
      delete :destroy, { id: <%= file_name %>.to_param }, valid_session
<% else -%>
      delete :destroy, params: { id: <%= file_name %>.to_param }, session: valid_session
<% end -%>
    end

    let!(:<%= ns_file_name %>) { create :<%= ns_file_name %> }

    it 'destroys the requested <%= ns_file_name %>' do
<% if options[:discard] -%>
      expect { subject }.to change(<%= class_name %>.kept, :count).by(-1)
<% elsif options[:paranoia] -%>
      expect { subject }.to change(<%= class_name %>.without_deleted, :count).by(-1)
<% else -%>
      expect { subject }.to change(<%= class_name %>, :count).by(-1)
<% end -%>
    end

    it 'setea el discarded_at' do
      subject
      expect(<%= ns_file_name %>.reload.discarded_at).to be_present
    end

    it 'redirects to the <%= table_name %> list' do
      subject
      expect(response).to redirect_to(<%= index_helper %>_url)
    end
  end
end
<% end -%>
