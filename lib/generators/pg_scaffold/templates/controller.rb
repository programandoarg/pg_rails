# generado con pg_rails

<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_name %>, only: [:show, :edit, :update, :destroy]

  add_breadcrumb <%= class_name %>.model_name.human.pluralize, :<%= plural_table_name %>_path

  before_action only: [:show, :edit, :update, :destroy] do
    authorize @<%= singular_name %>
  end

  before_action except: [:show, :edit, :update, :destroy] do
    authorize <%= class_name %>
  end

  def index
    @filtros = PgRails::FiltrosBuilder.new(
      self, <%= class_name %>, [<%= atributos_a_filtrar.map{|at| ":#{at.name}" }.join(', ') %>])
    @<%= plural_name %> = @filtros.filtrar <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.json { render json: @<%= plural_name %> }
      format.js { render_smart_listing }
      format.html { render_smart_listing }
      format.xlsx do
        render xlsx: 'download',
          filename: "#{<%= class_name %>.model_name.human.pluralize.gsub(' ','-').downcase}-#{Date.today}.xlsx"
      end
    end
  end

  def show
    add_breadcrumb @<%= singular_name %>, @<%= singular_name %>
    @<%= singular_name %> = @<%= singular_name %>.decorate

    respond_to do |format|
      format.json { render json: @cosas_category }
      format.html
    end
  end

  def new
    add_breadcrumb "Crear #{ <%= class_name %>.model_name.human.downcase }"

    @<%= singular_name %> = <%= orm_class.build(class_name) %>
    @<%= singular_name %> = @<%= singular_name %>.decorate
  end

  def edit
    add_breadcrumb @<%= singular_name %>
    @<%= singular_name %> = @<%= singular_name %>.decorate
  end

  def create
    @<%= singular_name %> = <%= orm_class.build(class_name, "#{singular_name}_params") %>
    @<%= singular_name %>.current_user = current_user

    respond_to do |format|
      if @<%= orm_instance(singular_name).save %>
        format.html { redirect_to @<%= singular_name %>, notice: "#{ <%= class_name %>.model_name.human } creadx." }
        format.json { render json: @<%= singular_name %>.decorate }
      else
        format.html { render :new }
        format.json { render json: @<%= singular_name %>.errors }
      end
    end
  end

  def update
    @<%= singular_name %>.assign_attributes(<%= "#{singular_name}_params" %>)
    @<%= singular_name %>.current_user = current_user

    respond_to do |format|
      if @<%= orm_instance(singular_name).save %>
        format.html { redirect_to @<%= singular_name %>, notice: "#{ <%= class_name %>.model_name.human } actualizadx." }
        format.json { render json: @<%= singular_name %>.decorate }
      else
        format.html { render :edit }
        format.json { render json: @<%= singular_name %>.errors }
      end
    end
  end

  def destroy
    destroy_and_respond(@<%= singular_name %>, <%= index_helper %>_url)
  end

  private

    def render_smart_listing
      smart_listing(:<%= plural_name %>, @<%= plural_name %>, '<%= ruta_vistas %>/listing')
    end

    def set_<%= singular_name %>
      @<%= singular_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    def <%= "#{singular_name}_params" %>
      <%- if attributes_names.empty? -%>
      params.fetch(:<%= singular_table_name %>, {})
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
