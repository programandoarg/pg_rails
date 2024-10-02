require 'rails_helper'

describe 'inline edit' do
  before do
    user = create :user
    sign_in user
  end

  let(:cosa) { create :cosa }

  describe '#show' do
    subject do
      get '/u/inline/show', params:, headers: { 'Turbo-Frame': turbo_frame_id }
    end

    let(:params) do
      { model: cosa.to_gid.to_param, attribute: :nombre }
    end

    let(:turbo_frame_id) { 'turbo-frame' }

    it do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to include cosa.nombre
    end

    context 'when no turbo frame targetted' do
      let(:turbo_frame_id) { nil }

      it do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '#edit' do
    subject do
      get '/u/inline/edit', params:, headers: { 'Turbo-Frame': turbo_frame_id }
    end

    let(:params) do
      { model: cosa.to_gid.to_param, attribute: :nombre }
    end

    let(:turbo_frame_id) { 'turbo-frame' }

    it do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to include cosa.nombre
    end

    context 'when no turbo frame targetted' do
      let(:turbo_frame_id) { nil }

      it do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '#update' do
    subject do
      patch "/u/cosas/#{cosa.to_param}", params:
    end

    let(:params) do
      {
        inline_attribute: 'nombre',
        cosa: {
          nombre:
        }
      }
    end

    let(:nombre) { 'otro' }

    it do
      subject
      expect(response.body).to include 'turbo-frame'
      expect(response).to have_http_status(:ok)
    end

    it do
      expect { subject }.to change { cosa.reload.nombre }.to 'otro'
    end

    context 'when validation fails' do
      let(:nombre) { nil }

      it do
        subject
        expect(response.body).to include 'turbo-frame'
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
