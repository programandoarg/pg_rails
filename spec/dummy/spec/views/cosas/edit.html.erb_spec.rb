# generado con pg_rails

require 'rails_helper'

RSpec.describe "cosas/edit", type: :view do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }

  before(:each) do
    sign_in user
    @cosa = assign(:cosa, create(:cosa).decorate)
    @clase_modelo = assign(:clase_modelo, Cosa)
  end

  it "renders the edit cosa form" do
    render

    assert_select "form[action=?][method=?]", cosa_path(@cosa), "post" do

      assert_select "input[name=?]", "cosa[nombre]"

      assert_select "select[name=?]", "cosa[tipo]"

      assert_select "select[name=?]", "cosa[categoria_de_cosa_id]"
    end
  end
end
