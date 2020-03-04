module PgRails
  class ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def editar_en_lugar?
      usuario_habilitado?
    end

    def index?
      usuario_habilitado?
    end

    def show?
      scope.where(:id => record.id).exists?
    end

    def create?
      usuario_habilitado?
    end

    def new?
      create?
    end

    def update?
      usuario_habilitado?
    end

    def edit?
      update?
    end

    def destroy?
      usuario_habilitado?
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
        if usuario_habilitado?
          scope
        else
          scope.none
        end
      end

      protected

        def usuario_habilitado?
          user.admin?
        end
    end

    protected

      def usuario_habilitado?
        user.admin?
      end
  end
end
