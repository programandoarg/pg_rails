# frozen_string_literal: true

# generado con pg_rails

class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # def resolve
    #   if policy.acceso_total?
    #     scope.all
    #   else
    #     scope.none
    #   end
    # end
  end

  # def acceso_total?
  #   user&.developer?
  # end
end
