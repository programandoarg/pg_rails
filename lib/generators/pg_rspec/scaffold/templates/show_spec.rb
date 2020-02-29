require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ns_table_name %>/show", <%= type_metatag(:view) %> do
  PgRails::ConfiguradorRSpec.helpers(self)

  let(:user) { create(:user, :admin) }

  before(:each) do
    @<%= singular_name %> = assign(:<%= singular_name %>, create(:<%= nombre_tabla_completo_singular %>))
  end

  it "renders attributes in <p>" do
    render
<% for attribute in output_attributes -%>
    expect(rendered).to match(/<%= raw_value_for(attribute).try :capitalize %>/)
<% end -%>
  end
end
