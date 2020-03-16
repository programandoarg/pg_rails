# generado con pg_rails

class CosasController < ApplicationController
  before_action { @clase_modelo = Cosa }

  before_action(only: :index) { authorize Cosa }

  before_action :set_cosa, only: %i[new create show edit update destroy]

  add_breadcrumb Cosa.nombre_plural, :cosas_path

  def index
    @cosas = filtros_y_policy [:nombre, :tipo, :categoria_de_cosa]

    respond_to do |format|
      format.json { render json: @cosas }
      format.js { render_smart_listing }
      format.html { render_smart_listing }
      format.xlsx do
        render xlsx: 'download',
          filename: "#{Cosa.nombre_plural.gsub(' ','-').downcase}-#{Date.today}.xlsx"
      end
    end
  end

  def show
    add_breadcrumb @cosa, @cosa

    respond_to do |format|
      format.json { render json: @cosa }
      format.html
    end
  end

  def new
    add_breadcrumb "Crear #{ Cosa.nombre_singular.downcase }"
  end

  def edit
    add_breadcrumb @cosa
  end

  def create
    respond_to do |format|
      if @cosa.save
        format.html { redirect_to @cosa, notice: "#{ Cosa.nombre_singular } creadx." }
        format.json { render json: @cosa.decorate }
      else
        format.html { render :new }
        format.json { render json: @cosa.errors }
      end
    end
  end

  def update
    respond_to do |format|
      if @cosa.save
        format.html { redirect_to @cosa, notice: "#{ Cosa.nombre_singular } actualizadx." }
        format.json { render json: @cosa.decorate }
      else
        format.html { render :edit }
        format.json { render json: @cosa.errors }
      end
    end
  end

  def destroy
    destroy_and_respond(@cosa, cosas_url)
  end

  private

    def render_smart_listing
      smart_listing(:cosas, @cosas, 'cosas/listing',
        sort_attributes: [
          [:nombre, "nombre"],
          [:tipo, "tipo"],
          [:categoria_de_cosa, "categoria_de_cosa"],
        ]
      )
    end

    def set_cosa
      if action_name.in? %w(new create)
        @cosa = @clase_modelo.new(cosa_params)
      else
        @cosa = @clase_modelo.find(params[:id])

        if action_name.in? %w(update)
          @cosa.assign_attributes(cosa_params)
        end
      end

      @cosa.current_user = current_user

      authorize @cosa

      if action_name.in? %w(show new edit)
        @cosa = @cosa.decorate
      end
    end

    def cosa_params
      if action_name == 'new'
        params.permit(atributos_permitidos)
      else
        params.require(:cosa).permit(atributos_permitidos)
      end
    end

    def atributos_permitidos
      [:nombre, :tipo, :categoria_de_cosa_id]
    end
end
