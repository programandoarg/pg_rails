# frozen_string_literal: true

# generado con pg_rails

module Admin
  class AccountsController < AdminController
    include PgEngine::Resource

    before_action { @clase_modelo = Account }

    before_action(only: :index) { authorize Account }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Account.nombre_plural, :admin_accounts_path

    private

    def atributos_permitidos
      %i[plan nombre]
    end

    def atributos_para_buscar
      %i[plan nombre]
    end

    def atributos_para_listar
      %i[plan nombre]
    end

    def atributos_para_mostrar
      %i[plan nombre]
    end
  end
end
