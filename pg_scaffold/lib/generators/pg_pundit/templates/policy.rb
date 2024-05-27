# frozen_string_literal: true

# generado con pg_rails

<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_policy"

<% end -%>
<% module_namespacing do -%>
class <%= class_name %>Policy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # def resolve
    #   if policy.base_access_to_collection?
    #     scope.all
    #   else
    #     scope.none
    #   end
    # end
  end

  # def puede_editar?
  #   base_access_to_record?
  # end

  # def puede_crear?
  #   base_access_to_collection?
  # end

  # def puede_borrar?
  #   base_access_to_record?
  # end

  # def base_access_to_record?
  #   base_access_to_collection? && record.account == Current.account
  # end

  # def base_access_to_collection?
  #   user.present?
  # end
end
<% end -%>
