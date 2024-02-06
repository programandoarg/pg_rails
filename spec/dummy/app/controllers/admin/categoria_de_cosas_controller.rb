# frozen_string_literal: true

# generado con pg_rails

module Admin
  class CategoriaDeCosasController < PgEngine::SignedInController
    before_action { @clase_modelo = CategoriaDeCosa }

    before_action(only: :index) { authorize CategoriaDeCosa }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb CategoriaDeCosa.nombre_plural, :admin_categoria_de_cosas_path

    def destroy
      pg_respond_destroy(@categoria_de_cosa, admin_categoria_de_cosas_url)
    end

    private

    def render_listing
      @collection = @collection.page(params[:page]).per(current_page_size)
    end

    def atributos_permitidos
      %i[nombre tipo fecha tiempo]
    end

    def atributos_para_buscar
      %i[nombre tipo fecha tiempo]
    end
  end
end
