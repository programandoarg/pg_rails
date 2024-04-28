# frozen_string_literal: true

# generado con pg_rails

module Public
  class MensajeContactosController < PublicController
    include PgEngine::Resource

    before_action { @clase_modelo = MensajeContacto }

    before_action(only: :index) { authorize MensajeContacto }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb MensajeContacto.nombre_plural, :public_mensaje_contactos_path

    private

    def atributos_permitidos
      %i[nombre email telefono mensaje]
    end

    def atributos_para_buscar
      %i[nombre email telefono mensaje]
    end

    def atributos_para_listar
      %i[nombre email telefono mensaje]
    end

    def atributos_para_mostrar
      %i[nombre email telefono mensaje]
    end
  end
end
