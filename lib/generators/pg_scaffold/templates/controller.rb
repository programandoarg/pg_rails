# generado con https://github.com/programandoarg/slim_smart_listing_rails

<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  add_breadcrumb <%= class_name %>.model_name.human.pluralize, :<%= plural_table_name %>_path

  before_action only: [:show, :edit, :update, :destroy] do
    authorize @<%= singular_table_name %>
  end

  before_action except: [:show, :edit, :update, :destroy] do
    authorize <%= class_name %>
  end

  def index
    @filtros = PgRails::FiltrosBuilder.new(
      self, <%= class_name %>, [<%= atributos_a_filtrar.map{|at| ":#{at.name}" }.join(', ') %>])
    @<%= plural_table_name %> = @filtros.filtrar <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.json { render json: @<%= plural_table_name %> }
      format.js { render_smart_listing }
      format.html { render_smart_listing }
      format.xlsx { render xlsx: 'download', filename: "<%= plural_table_name %>-#{Date.today}.xlsx" }
    end
  end

  def show
    add_breadcrumb @<%= singular_table_name %>, @<%= singular_table_name %>
    @<%= singular_table_name %> = @<%= singular_table_name %>.decorate
  end

  def new
    add_breadcrumb "Crear #{ <%= class_name %>.model_name.human.downcase }"

    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    @<%= singular_table_name %> = @<%= singular_table_name %>.decorate
  end

  def edit
    add_breadcrumb @<%= singular_table_name %>
    @<%= singular_table_name %> = @<%= singular_table_name %>.decorate
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    @<%= singular_table_name %>.current_user = current_user

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: "#{ <%= class_name %>.model_name.human } creadx."
    else
      render :new
    end
  end

  def update
    @<%= singular_table_name %>.assign_attributes(<%= "#{singular_table_name}_params" %>)
    @<%= singular_table_name %>.current_user = current_user

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: "#{ <%= class_name %>.model_name.human } actualizadx."
    else
      render :edit
    end
  end

  def destroy
    destroy_and_respond(@<%= singular_table_name %>, <%= index_helper %>_url)
  end

  private

    def render_smart_listing
      smart_listing(:<%= plural_table_name %>, @<%= plural_table_name %>, '<%= ruta_vistas %>/listing')
    end

    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params.fetch(:<%= singular_table_name %>, {})
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
