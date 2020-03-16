# generado con pg_rails

require 'rails_helper'

RSpec.describe "cosas/index", type: :view do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }
  let!(:cosas) { create_list(:cosa, rand(10..20))}

  before(:each) do
    sign_in user
    @clase_modelo = assign(:clase_modelo, Cosa)
    smart_listing_create :cosas, Cosa.all, partial: 'cosas/listing'

    assign(:filtros, PgRails::FiltrosBuilder.new(
      self, Cosa, []))
  end

  it "renders a list of cosas" do
    render
    assert_select "table", 1
  end
end
