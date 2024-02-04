# frozen_string_literal: true

# generado con pg_rails

<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing_2 do -%>
class <%= controller_class_name.split('::').last %>Controller < ApplicationController
  before_action { @clase_modelo = <%= class_name %> }

  before_action(only: :index) { authorize <%= class_name %> }

  before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

  add_breadcrumb <%= class_name %>.nombre_plural, :<%= plural_route_name %>_path

  def abrir_modal
    pg_respond_abrir_modal
  end

  def buscar
    pg_respond_buscar
  end

  def index
    @<%= plural_name %> = filtros_y_policy %i[<%= atributos_a_filtrar.map(&:name).join(' ') %>]
    @<%= plural_name %> = sort_collection(@<%= plural_name %>)
    pg_respond_index(@<%= plural_name %>)
  end

  def show
    add_breadcrumb @<%= singular_name %>, @<%= singular_name %>.target_object

    pg_respond_show
  end

  def new
    add_breadcrumb "Crear #{<%= class_name %>.nombre_singular.downcase}"
  end

  def edit
    add_breadcrumb @<%= singular_name %>, @<%= singular_name %>.target_object
    add_breadcrumb 'Editando'
  end

  def create
    pg_respond_create
  end

  def update
    pg_respond_update
  end

  def destroy
    pg_respond_destroy(@<%= singular_name %>, <%= index_helper %>_url)
  end

  private

  def render_listing
    @<%= plural_name %> = @<%= plural_name %>.page(params[:page]).per(current_page_size)
  end

  def atributos_permitidos
    %i[<%= attributes_names.join(' ') %>]
  end
end
<% end -%>
