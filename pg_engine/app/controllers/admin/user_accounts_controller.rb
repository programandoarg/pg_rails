# frozen_string_literal: true

# generado con pg_rails

module Admin
  class UserAccountsController < AdminController
    before_action { @clase_modelo = UserAccount }

    before_action(only: :index) { authorize UserAccount }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb UserAccount.nombre_plural, :admin_user_accounts_path

    private

    def atributos_permitidos
      %i[user_id account_id profiles]
    end

    def atributos_para_buscar
      %i[user account profiles]
    end

    def atributos_para_listar
      %i[user account profiles]
    end

    def atributos_para_mostrar
      %i[user account profiles]
    end
  end
end
