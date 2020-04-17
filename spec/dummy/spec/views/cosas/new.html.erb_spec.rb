# generado con pg_rails

require 'rails_helper'

RSpec.describe "cosas/new", type: :view do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }

  before(:each) do
    sign_in user
    @cosa = assign(:cosa, build(:cosa).decorate)
    @clase_modelo = assign(:clase_modelo, Cosa)
  end

  it "renders new cosa form" do
    render

    assert_select "form[action=?][method=?]", cosas_path, "post" do

      assert_select "input[name=?]", "cosa[nombre]"

      assert_select "select[name=?]", "cosa[tipo]"

      assert_select "input[name=?]", "cosa[categoria_de_cosa_id]"
    end
  end
end
