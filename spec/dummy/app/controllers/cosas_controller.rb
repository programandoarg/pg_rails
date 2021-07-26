# frozen_string_literal: true

# generado con pg_rails

class CosasController < ApplicationController
  before_action { @clase_modelo = Cosa }

  before_action(only: :index) { authorize Cosa }

  before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

  add_breadcrumb Cosa.nombre_plural, :cosas_path

  def index
    @filtros = PgRails::FiltrosBuilder.new(
      self, clase_modelo, %i[nombre tipo categoria_de_cosa]
    )
    scope = policy_scope(clase_modelo)

    @filtros.scope_asociacion(:categoria_de_cosa) do |scope|
      scope.limit(3)
    end

    @cosas = @filtros.filtrar(scope)

    pg_respond_index(@cosas)
  end

  def show
    add_breadcrumb @cosa, @cosa

    pg_respond_show
  end

  def new
    add_breadcrumb "Crear #{Cosa.nombre_singular.downcase}"
  end

  def edit
    add_breadcrumb @cosa
  end

  def create
    pg_respond_create
  end

  def update
    pg_respond_update
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

    def atributos_permitidos
      %i[nombre tipo categoria_de_cosa_id]
    end
end
