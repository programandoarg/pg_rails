# generado con pg_rails

require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ruta_vistas %>/show", <%= type_metatag(:view) %> do
  PgRails::ConfiguradorRSpec.helpers(self)
<% if mountable_engine? -%>
  helper <%= mountable_engine? %>::Engine.routes.url_helpers
<% end -%>

  let(:user) { create(:user, :admin) }

  before(:each) do
    sign_in user
    @<%= singular_name %> = assign(:<%= singular_name %>, create(:<%= nombre_tabla_completo_singular %>).decorate)
    @clase_modelo = assign(:clase_modelo, <%= nombre_clase_completo %>)
  end

  it "renders attributes in <p>" do
    render
<% for attribute in output_attributes -%>
    expect(rendered).to match(/<%= raw_value_for(attribute).try :capitalize %>/)
<% end -%>
  end
end
