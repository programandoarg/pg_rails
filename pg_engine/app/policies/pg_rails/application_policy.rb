# frozen_string_literal: true

module PgRails
  class ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def editar_en_lugar?
      puede_editar?
    end

    def index?
      raise "esta policy se llama con la clase modelo y no con #{record.class}" unless record.class

      acceso_total? || Pundit.policy_scope!(user, record).any?
    end

    def show?
      # scope.where(id: record.id).exists?
      acceso_total?
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
        if policy.acceso_total?
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
      acceso_total?
    end

    def puede_crear?
      acceso_total?
    end

    def puede_borrar?
      acceso_total?
    end

    def export?
      acceso_total?
    end

    def acceso_total?
      user&.admin?
    end

    def objeto_borrado?
      if record.respond_to?(:deleted?)
        record.deleted?
      elsif record.respond_to?(:discarded?)
        record.discarded?
      else
        false
      end
    end
  end
end
