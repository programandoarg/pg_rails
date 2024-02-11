# frozen_string_literal: true

# generado con pg_rails

module Admin
  class AccountsController < AdminController
    before_action { @clase_modelo = Account }

    before_action(only: :index) { authorize Account }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Account.nombre_plural, :admin_accounts_path

    private

    def atributos_permitidos
      %i[plan nombre hashid]
    end

    def atributos_para_buscar
      %i[plan nombre hashid]
    end

    def atributos_para_listar
      %i[plan nombre hashid]
    end

    def atributos_para_mostrar
      %i[plan nombre hashid]
    end
  end
end
