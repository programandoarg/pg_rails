require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ns_table_name %>/index", <%= type_metatag(:view) %> do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }
  let!(:<%= plural_name %>) { create_list(:<%= nombre_tabla_completo_singular %>, rand(10..20))}

  before(:each) do
    create_list(:<%= singular_table_name %>, 10)
    smart_listing_create :<%= plural_name %>, <%= class_name %>.all, partial: '<%= ruta_vistas %>/listing'

    assign(:filtros, PgRails::FiltrosBuilder.new(
      self, <%= class_name %>, []))
  end

  it "renders a list of <%= ns_table_name %>" do
    render
    assert_select "table", 1
  end
end
