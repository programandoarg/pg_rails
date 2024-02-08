# frozen_string_literal: true

# generado con pg_rails

module Admin
  class CosasController < AdminController
    before_action { @clase_modelo = Cosa }

    before_action(only: :index) { authorize Cosa }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Cosa.nombre_plural, :admin_cosas_path

    private

    def atributos_permitidos
      %i[nombre tipo categoria_de_cosa_id]
    end

    def atributos_para_buscar
      %i[nombre tipo categoria_de_cosa]
    end

    def atributos_para_listar
      %i[nombre tipo categoria_de_cosa]
    end

    def atributos_para_mostrar
      %i[nombre tipo categoria_de_cosa]
    end
  end
end
