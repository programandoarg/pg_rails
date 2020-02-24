require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ns_table_name %>/index", <%= type_metatag(:view) %> do
  helper  SmartListing::Helper

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
