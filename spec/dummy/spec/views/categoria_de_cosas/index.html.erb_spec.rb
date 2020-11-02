# generado con pg_rails

require 'rails_helper'

RSpec.describe "categoria_de_cosas/index", type: :view do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }
  let!(:categoria_de_cosas) { create_list(:categoria_de_cosa, rand(10..20))}

  before(:each) do
    sign_in user
    @clase_modelo = assign(:clase_modelo, CategoriaDeCosa)
    smart_listing_create :categoria_de_cosas, CategoriaDeCosa.all, partial: 'categoria_de_cosas/listing'

    assign(:filtros, PgRails::FiltrosBuilder.new(
      self, CategoriaDeCosa, []))
  end

  it "renders a list of categoria_de_cosas" do
    render
    assert_select "table", 1
  end
end
