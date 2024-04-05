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

  def puede_editar?
    true
  end

  def puede_crear?
    true
  end

  def puede_borrar?
    false
  end

  def acceso_total?
    false
  end
end
