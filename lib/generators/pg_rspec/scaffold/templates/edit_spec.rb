# generado con pg_rails

require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ruta_vistas %>/edit", <%= type_metatag(:view) %> do
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

  it "renders the edit <%= singular_name %> form" do
    render

    assert_select "form[action=?][method=?]", <%= ns_file_name %>_path(@<%= singular_name %>), "post" do
<% for attribute in output_attributes -%>
      <%- name = attribute.respond_to?(:column_name) ? attribute.column_name : attribute.name %>
<% if Rails.version.to_f >= 5.1 -%>
      assert_select "<%= attribute.input_type -%>[name=?]", "<%= ns_file_name %>[<%= name %>]"
<% else -%>
      assert_select "<%= attribute.input_type -%>#<%= ns_file_name %>_<%= name %>[name=?]", "<%= ns_file_name %>[<%= name %>]"
<% end -%>
<% end -%>
    end
  end
end
