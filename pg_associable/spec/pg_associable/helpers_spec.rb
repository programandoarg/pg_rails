require 'rails_helper'

describe PgAssociable::Helpers do
  describe '#pg_respond_buscar' do
    let(:user) { create :user, :developer }
    let(:ctrl) do
      # clazz = Class.new(Admin::CosasController)
      # clazz.new
      Admin::CosasController.new
    end
    let!(:cosa) { create :cosa }

    before do
      allow(ctrl).to receive_messages(current_user: user, params: { id: 123, query: cosa.id })
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
