# frozen_string_literal: true

# generado con pg_rails

module Admin
  class CosasController < AdminController
    include PgEngine::Resource

    # TODO: maybe use constants?
    # habría que ver cómo acceder a las mismas desde la superclase, pero
    # se debería poder
    self.clase_modelo = Cosa
    self.nested_class = CategoriaDeCosa
    self.nested_key = :categoria_de_cosa_id

    before_action(only: :index) { authorize Cosa }
    # before_action(only: :index) { @sidebar = false }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    before_action(only: :show) do
      CosaMailer.with(cosa: @cosa).cosa.deliver_later if params[:send_mail] == 'true'
    end

    private

    def default_sort
      'cosas.nombre asc'
    end

    def atributos_permitidos
      %i[nombre tipo categoria_de_cosa_id rico]
    end

    def inside_categoria?
      nested_id.present?
    end

    def atributos_para_buscar
      if inside_categoria?
        %i[nombre tipo_in creado_por]
      else
        %i[nombre tipo_in categoria_de_cosa_id_in categoria_de_cosa_nombre_cont creado_por]
      end
    end

    def atributos_para_listar
      if inside_categoria?
        %i[
          nombre
          tipo_text
        ]
      else
        [
          :nombre,
          :tipo_text,
          %i[categoria_de_cosa categoria_de_cosa_nombre]
        ]
      end
    end

    def atributos_para_mostrar
      %i[nombre tipo categoria_de_cosa rico]
    end
  end
end
