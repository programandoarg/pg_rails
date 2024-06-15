require 'rails_helper'

describe 'Base requests' do
  describe 'invalid authenticity token' do
    subject { get '/admin/cosas', headers: }

    before do
      sign_in create(:user, :developer)
      allow_any_instance_of(Admin::CosasController).to \
        receive(:index).and_raise(ActionController::InvalidAuthenticityToken)
    end

    shared_examples 'manda el status correcto' do
      it do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end

    it do
      expect { subject }.to have_warned
    end

    context 'cuando pide html' do
      let(:headers) do
        { 'ACCEPT' => 'text/html' }
      end

      include_examples 'manda el status correcto'

      it 'no manda el flash' do
        subject
        expect(flash).to be_empty
      end

      it 'muestra el mensaje' do
        subject
        expect(response.body).to include 'Solicitud incorrecta'
      end
    end

    context 'cuando pide turbo_stream' do
      let(:headers) do
        { 'ACCEPT' => 'text/vnd.turbo-stream.html' }
      end

      include_examples 'manda el status correcto'

      it 'manda el flash' do
        subject
        expect(flash[:alert]).to include 'Solicitud incorrecta'
      end
    end

    context 'cuando pide json' do
      let(:headers) do
        { 'ACCEPT' => 'application/json' }
      end

      include_examples 'manda el status correcto'
    end
  end
end
