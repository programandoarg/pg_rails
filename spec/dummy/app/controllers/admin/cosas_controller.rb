# frozen_string_literal: true

# generado con pg_rails

module Admin
  class CosasController < ApplicationController
    before_action { @clase_modelo = Cosa }

    before_action(only: :index) { authorize Cosa }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Cosa.nombre_plural, :admin_cosas_path

    def abrir_modal
      pg_respond_abrir_modal
    end

    def buscar
      pg_respond_buscar
    end

    def index
      @cosas = filtros_y_policy %i[nombre apellido persona]
      @cosas = sort_collection(@cosas)
      pg_respond_index(@cosas)
    end

    def show
      add_breadcrumb @cosa, @cosa.target_object

      pg_respond_show
    end

    def new
      add_breadcrumb "Crear #{Cosa.nombre_singular.downcase}"
    end

    def edit
      add_breadcrumb @cosa, @cosa.target_object
      add_breadcrumb 'Editando'
    end

    def create
      pg_respond_create
    end

    def update
      pg_respond_update
    end

    def destroy
      pg_respond_destroy(@cosa, admin_cosas_url)
    end

    private

    def render_listing
      @cosas = @cosas.page(params[:page]).per(current_page_size)
    end

    def atributos_permitidos
      %i[nombre apellido persona_id]
    end
  end
end
