# frozen_string_literal: true

# generado con pg_rails

module Frontend
  class CategoriaDeCosasController < FrontendController
    include PgEngine::Resource

    before_action { @clase_modelo = CategoriaDeCosa }

    before_action(only: :index) { authorize CategoriaDeCosa }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb CategoriaDeCosa.nombre_plural, :frontend_categoria_de_cosas_path

    private

    def atributos_permitidos
      %i[nombre tipo fecha tiempo]
    end

    def atributos_para_buscar
      %i[nombre tipo fecha tiempo]
    end

    def atributos_para_listar
      %i[nombre tipo fecha tiempo]
    end

    def atributos_para_mostrar
      %i[nombre tipo fecha tiempo]
    end
  end
end
