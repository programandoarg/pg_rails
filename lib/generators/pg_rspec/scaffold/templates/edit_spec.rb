require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ns_table_name %>/edit", <%= type_metatag(:view) %> do
  before(:each) do
    @<%= singular_name %> = assign(:<%= singular_name %>, create(:<%= ns_file_name %>))
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
