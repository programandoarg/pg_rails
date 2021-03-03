# frozen_string_literal: true

# generado con pg_rails

class CategoriaDeCosasController < ApplicationController
  before_action { @clase_modelo = CategoriaDeCosa }

  before_action(only: :index) { authorize CategoriaDeCosa }

  before_action :set_categoria_de_cosa, only: %i[new create show edit update destroy]

  add_breadcrumb CategoriaDeCosa.nombre_plural, :categoria_de_cosas_path

  def index
    @categoria_de_cosas = filtros_y_policy %i[nombre tipo fecha tiempo]

    pg_respond_index(@categoria_de_cosas)
  end

  def show
    add_breadcrumb @categoria_de_cosa, @categoria_de_cosa

    respond_to do |format|
      format.json { render json: @categoria_de_cosa }
      format.html
    end
  end

  def new
    add_breadcrumb "Crear #{CategoriaDeCosa.nombre_singular.downcase}"
  end

  def edit
    add_breadcrumb @categoria_de_cosa
  end

  def create
    pg_respond_create(@categoria_de_cosa)
  end

  def update
    pg_respond_update(@categoria_de_cosa)
  end

  def destroy
    pg_respond_destroy(@categoria_de_cosa, categoria_de_cosas_url)
  end

  private

    def render_smart_listing
      smart_listing(:categoria_de_cosas, @categoria_de_cosas, 'categoria_de_cosas/listing',
                    sort_attributes: [
                      [:nombre, 'nombre'],
                      [:tipo, 'tipo'],
                      [:fecha, 'fecha'],
                      [:tiempo, 'tiempo']
                    ])
    end

    def set_categoria_de_cosa
      if action_name.in? %w[new create]
        @categoria_de_cosa = @clase_modelo.new(categoria_de_cosa_params)
      else
        @categoria_de_cosa = @clase_modelo.find(params[:id])

        @categoria_de_cosa.assign_attributes(categoria_de_cosa_params) if action_name.in? %w[update]
      end

      @categoria_de_cosa.current_user = current_user

      authorize @categoria_de_cosa

      @categoria_de_cosa = @categoria_de_cosa.decorate if action_name.in? %w[show new edit]
    end

    def categoria_de_cosa_params
      if action_name == 'new'
        params.permit(atributos_permitidos)
      else
        params.require(:categoria_de_cosa).permit(atributos_permitidos)
      end
    end

    def atributos_permitidos
      %i[nombre tipo fecha tiempo]
    end
end
