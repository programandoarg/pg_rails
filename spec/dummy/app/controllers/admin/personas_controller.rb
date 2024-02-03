# frozen_string_literal: true

# generado con pg_rails

module Admin
  class PersonasController < ApplicationController
    before_action { @clase_modelo = Persona }

    before_action(only: :index) { authorize Persona }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Persona.nombre_plural, :admin_personas_path

    def abrir_modal
      pg_respond_abrir_modal
    end

    def buscar
      pg_respond_buscar
    end

    def index
      @personas = filtros_y_policy %i[nombre apellido]
      @personas = sort_collection(@personas)
      pg_respond_index(@personas)
    end

    def show
      add_breadcrumb @persona, @persona.target_object

      pg_respond_show
    end

    def new
      add_breadcrumb "Crear #{Persona.nombre_singular.downcase}"
    end

    def edit
      add_breadcrumb @persona, @persona.target_object
      add_breadcrumb 'Editando'
    end

    def create
      pg_respond_create
    end

    def update
      pg_respond_update
    end

    def destroy
      pg_respond_destroy(@persona, admin_personas_url)
    end

    private

    def render_listing
      @personas = @personas.page(params[:page]).per(current_page_size)
    end

    def atributos_permitidos
      %i[nombre apellido]
    end
  end
end
