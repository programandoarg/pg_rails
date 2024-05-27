# frozen_string_literal: true

module PgEngine
  class BasePolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def index?
      base_access_to_collection?
    end

    def show?
      # scope.where(id: record.id).exists?
      base_access_to_record?
    end

    def create?
      puede_crear?
    end

    def new?
      create?
    end

    def update?
      puede_editar? && !objeto_borrado?
    end

    def edit?
      update?
    end

    def destroy?
      puede_borrar? && !objeto_borrado?
    end

    def scope
      Pundit.policy_scope!(user, record.class)
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        if policy.base_access_to_collection?
          scope.all
        else
          scope.none
        end
      end

      def policy
        raise "el scope debe ser una clase modelo y no #{scope.class}" unless scope.class

        Pundit.policy!(user, scope)
      end
    end

    def puede_editar?
      base_access_to_record?
    end

    def puede_crear?
      base_access_to_collection?
    end

    def puede_borrar?
      base_access_to_record?
    end

    def export?
      base_access_to_collection?
    end

    def base_access_to_record?
      user&.developer?
    end

    def base_access_to_collection?
      user&.developer?
    end

    def objeto_borrado?
      if record.respond_to?(:discarded?)
        record.discarded?
      else
        false
      end
    end
  end
end
