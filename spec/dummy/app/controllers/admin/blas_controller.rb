# frozen_string_literal: true

# generado con pg_rails

module Admin
  class BlasController < PgEngine::SignedInController
    before_action { @clase_modelo = Bla }

    before_action(only: :index) { authorize Bla }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Bla.nombre_plural, :admin_blas_path

    def abrir_modal
      pg_respond_abrir_modal
    end

    def buscar
      pg_respond_buscar
    end

    def index
      @blas = filtros_y_policy %i[nombre tipo categoria_de_cosa]
      @blas = sort_collection(@blas)
      pg_respond_index(@blas)
    end

    def show
      add_breadcrumb @bla, @bla.target_object

      pg_respond_show
    end

    def new
      add_breadcrumb "Crear #{Bla.nombre_singular.downcase}"
    end

    def edit
      add_breadcrumb @bla, @bla.target_object
      add_breadcrumb 'Editando'
    end

    def create
      pg_respond_create
    end

    def update
      pg_respond_update
    end

    def destroy
      pg_respond_destroy(@bla, admin_blas_url)
    end

    private

    def render_listing
      @blas = @blas.page(params[:page]).per(current_page_size)
    end

    def atributos_permitidos
      %i[nombre tipo categoria_de_cosa_id]
    end
  end
end
