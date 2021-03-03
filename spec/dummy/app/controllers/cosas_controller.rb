# frozen_string_literal: true

# generado con pg_rails

class CosasController < ApplicationController
  before_action { @clase_modelo = Cosa }

  before_action(only: :index) { authorize Cosa }

  before_action :set_cosa, only: %i[new create show edit update destroy]

  add_breadcrumb Cosa.nombre_plural, :cosas_path

  def index
    @cosas = filtros_y_policy %i[nombre tipo categoria_de_cosa]

    pg_respond_index(@cosas)
  end

  def show
    add_breadcrumb @cosa, @cosa

    respond_to do |format|
      format.json { render json: @cosa }
      format.html
    end
  end

  def new
    add_breadcrumb "Crear #{Cosa.nombre_singular.downcase}"
  end

  def edit
    add_breadcrumb @cosa
  end

  def create
    pg_respond_create(@cosa)
  end

  def update
    pg_respond_update(@cosa)
  end

  def destroy
    pg_respond_destroy(@cosa, cosas_url)
  end

  private

    def render_smart_listing
      smart_listing(:cosas, @cosas, 'cosas/listing',
                    sort_attributes: [
                      [:nombre, 'nombre'],
                      [:tipo, 'tipo'],
                      [:categoria_de_cosa, 'categoria_de_cosa']
                    ])
    end

    def set_cosa
      if action_name.in? %w[new create]
        @cosa = @clase_modelo.new(cosa_params)
      else
        @cosa = @clase_modelo.find(params[:id])

        @cosa.assign_attributes(cosa_params) if action_name.in? %w[update]
      end

      @cosa.current_user = current_user

      authorize @cosa

      @cosa = @cosa.decorate if action_name.in? %w[show new edit]
    end

    def cosa_params
      if action_name == 'new'
        params.permit(atributos_permitidos)
      else
        params.require(:cosa).permit(atributos_permitidos)
      end
    end

    def atributos_permitidos
      %i[nombre tipo categoria_de_cosa_id]
    end
end
