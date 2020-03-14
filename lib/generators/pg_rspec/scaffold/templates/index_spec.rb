# generado con pg_rails

require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ruta_vistas %>/index", <%= type_metatag(:view) %> do
  PgRails::ConfiguradorRSpec.helpers(self)
<% if mountable_engine? -%>
  helper <%= mountable_engine? %>::Engine.routes.url_helpers
<% end -%>

  let(:user) { create(:user, :admin) }
  let!(:<%= plural_name %>) { create_list(:<%= nombre_tabla_completo_singular %>, rand(10..20))}

  before(:each) do
    sign_in user
    @clase_modelo = assign(:clase_modelo, <%= nombre_clase_completo %>)
    smart_listing_create :<%= plural_name %>, <%= nombre_clase_completo %>.all, partial: '<%= ruta_vistas %>/listing'

    assign(:filtros, PgRails::FiltrosBuilder.new(
      self, <%= nombre_clase_completo %>, []))
  end

  it "renders a list of <%= ns_table_name %>" do
    render
    assert_select "table", 1
  end
end
