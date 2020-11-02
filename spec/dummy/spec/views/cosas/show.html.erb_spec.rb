# generado con pg_rails

require 'rails_helper'

RSpec.describe "cosas/show", type: :view do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }

  before(:each) do
    sign_in user
    @cosa = assign(:cosa, create(:cosa).decorate)
    @clase_modelo = assign(:clase_modelo, Cosa)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nombre/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
