# generado con pg_rails

<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_policy"

<% end -%>
<% module_namespacing do -%>
class <%= class_name %>Policy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
  end
end
<% end -%>
