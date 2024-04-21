require 'rails_helper'

describe PgAssociable::Helpers do
  describe '#pg_respond_buscar' do
    let(:ctrl) do
      Admin::CosasController.new
    end
    let!(:cosa) { create :cosa }

    before do
      Current.user = create :user, :developer
      allow(ctrl).to receive_messages(params: { id: 123, query: cosa.id })
      allow(ctrl).to receive(:render)
      ctrl.instance_variable_set(:@clase_modelo, Cosa)
    end

    it do
      ctrl.pg_respond_buscar
      cosas = ctrl.instance_variable_get(:@collection)
      expect(cosas).to eq [cosa]
    end
  end
end
