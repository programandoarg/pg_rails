# generado con pg_rails

require 'rails_helper'

RSpec.describe "categoria_de_cosas/edit", type: :view do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }

  before(:each) do
    sign_in user
    @categoria_de_cosa = assign(:categoria_de_cosa, create(:categoria_de_cosa).decorate)
    @clase_modelo = assign(:clase_modelo, CategoriaDeCosa)
  end

  it "renders the edit categoria_de_cosa form" do
    render

    assert_select "form[action=?][method=?]", categoria_de_cosa_path(@categoria_de_cosa), "post" do

      assert_select "input[name=?]", "categoria_de_cosa[nombre]"

      assert_select "select[name=?]", "categoria_de_cosa[tipo]"
    end
  end
end
