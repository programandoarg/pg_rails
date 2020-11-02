# generado con pg_rails

require 'rails_helper'

RSpec.describe "categoria_de_cosas/show", type: :view do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }

  before(:each) do
    sign_in user
    @categoria_de_cosa = assign(:categoria_de_cosa, create(:categoria_de_cosa).decorate)
    @clase_modelo = assign(:clase_modelo, CategoriaDeCosa)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nombre/)
    expect(rendered).to match(//)
  end
end
