# frozen_string_literal: true

# generado con pg_rails

module Admin
  class CategoriaDeCosasController < ApplicationController
    before_action { @clase_modelo = CategoriaDeCosa }

    before_action(only: :index) { authorize CategoriaDeCosa }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb CategoriaDeCosa.nombre_plural, :admin_categoria_de_cosas_path

    def abrir_modal
      pg_respond_abrir_modal
    end

    def buscar
      pg_respond_buscar
    end

    def index
      @categoria_de_cosas = filtros_y_policy %i[nombre tipo fecha tiempo]
      @categoria_de_cosas = sort_collection(@categoria_de_cosas)
      pg_respond_index(@categoria_de_cosas)
    end

    def show
      add_breadcrumb @categoria_de_cosa, @categoria_de_cosa.target_object

      pg_respond_show
    end

    def new
      add_breadcrumb "Crear #{CategoriaDeCosa.nombre_singular.downcase}"
    end

    def edit
      add_breadcrumb @categoria_de_cosa, @categoria_de_cosa.target_object
      add_breadcrumb 'Editando'
    end

    def create
      pg_respond_create
    end

    def update
      pg_respond_update
    end

    def destroy
      pg_respond_destroy(@categoria_de_cosa, admin_categoria_de_cosas_url)
    end

    private

    def render_listing
      @categoria_de_cosas = @categoria_de_cosas.page(params[:page]).per(current_page_size)
    end

    def atributos_permitidos
      %i[nombre tipo fecha tiempo]
    end
  end
end
