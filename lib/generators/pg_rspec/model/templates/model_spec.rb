# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
  let(:<%= singular_name %>) { create(:<%= singular_table_name %>) }

  it 'se persiste' do
    expect(<%= singular_name %>).to be_persisted
  end
end
<% end -%>
