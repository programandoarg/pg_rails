module PgEngine
  module ResourceHelper
    def self.included(clazz)
      clazz.before_action :authenticate_user!
      clazz.helper_method :atributos_para_listar
      clazz.helper_method :atributos_para_mostrar
      clazz.helper_method :current_page_size
      clazz.helper_method :any_filter?
    end

    # Public endpoints
    def abrir_modal
      pg_respond_abrir_modal
    end

    def buscar
      pg_respond_buscar
    end

    def index
      @collection = filtros_y_policy atributos_para_buscar
      @collection = sort_collection(@collection)
      pg_respond_index
    end

    def show
      add_breadcrumb instancia_modelo, instancia_modelo.target_object

      pg_respond_show
    end

    def new
      add_breadcrumb 'Crear'
    end

    def edit
      add_breadcrumb instancia_modelo, instancia_modelo.target_object
      add_breadcrumb 'Editando'
    end

    def create
      pg_respond_create
    end

    def update
      pg_respond_update
    end

    def destroy
      url = namespaced_path(@clase_modelo)
      pg_respond_destroy(instancia_modelo, url)
    end
    # End public endpoints

    protected

    def any_filter?
      params.keys.reject { |a| a.in? %w[controller action page page_size order_by order_direction] }.any?
    end

    def current_page_size
      if params[:page_size].present?
        session[:page_size] = params[:page_size]
        params[:page_size].to_i
      else
        default_page_size
      end
    end

    def default_page_size
      session[:page_size].present? ? session[:page_size].to_i : 10
    end

    def pg_respond_update
      object = instancia_modelo
      respond_to do |format|
        if (@saved = object.save)
          format.html { redirect_to object.decorate.target_object }
          format.json { render json: object.decorate }
        else
          # TODO: esto solucionaría el problema?
          # self.instancia_modelo = instancia_modelo.decorate
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: object.errors, status: :unprocessable_entity }
        end
      end
    end

    def pg_respond_create
      object = instancia_modelo
      respond_to do |format|
        if (@saved = object.save)
          if params[:asociable]
            format.turbo_stream do
              render turbo_stream:
                # rubocop:disable Rails/SkipsModelValidations
                turbo_stream.update_all('.modal.show .pg-associable-form', <<~HTML
                  <div data-modal-target="response" data-response='#{object.decorate.to_json}'></div>
                HTML
                )
              # rubocop:enable Rails/SkipsModelValidations
            end
          end
          format.html do
            if params[:save_and_next] == 'true'
              new_path = "#{url_for(@clase_modelo)}/new"
              redirect_to new_path, notice: "#{@clase_modelo.nombre_singular} creado."
            else
              redirect_to object.decorate.target_object
            end
          end
          format.json { render json: object.decorate }
        else
          # TODO: esto solucionaría el problema?
          # self.instancia_modelo = instancia_modelo.decorate
          if params[:asociable]
            format.turbo_stream do
              # rubocop:disable Rails/SkipsModelValidations
              render turbo_stream:
                turbo_stream.update_all('.modal.show .pg-associable-form', partial: 'form', locals: { asociable: true })
              # rubocop:enable Rails/SkipsModelValidations
            end
          end
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: object.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end

    def pg_respond_index
      respond_to do |format|
        format.json { render json: @collection }
        format.html { render_listing }
        format.xlsx do
          render xlsx: 'download',
                 filename: "#{@clase_modelo.nombre_plural.gsub(' ', '-').downcase}" \
                           "-#{Time.zone.now.strftime('%Y-%m-%d-%H.%M.%S')}.xlsx"
        end
      end
    end

    def pg_respond_show(object = nil)
      respond_to do |format|
        format.json { render json: object || instancia_modelo }
        format.html
      end
    end

    def pg_respond_destroy(model, redirect_url = nil)
      if destroy_model(model)
        respond_to do |format|
          format.html do
            if redirect_url.present?
              redirect_to redirect_url, notice: 'Elemento borrado.', status: :see_other
            else
              redirect_back(fallback_location: root_path, notice: 'Elemento borrado.', status: 303)
            end
          end
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html do
            if model.respond_to?(:associated_elements) && model.associated_elements.present?
              @model = model
              render destroy_error_details_view
            else
              flash[:alert] = @error_message
              # if redirect_url.present?
              #   redirect_to redirect_url
              # else
              redirect_back(fallback_location: root_path, status: 303)
              # end
            end
          end
          format.json { render json: { error: @error_message }, status: :unprocessable_entity }
        end
      end
    end

    # TODO: crear esta vista en pg_rails
    def destroy_error_details_view
      'destroy_error_details'
    end

    def destroy_model(model)
      @error_message = 'No se pudo eliminar el registro'
      begin
        destroy_method = model.respond_to?(:discard) ? :discard : :destroy
        return true if model.send(destroy_method)

        @error_message = model.errors.full_messages.join(', ')
        false
      rescue ActiveRecord::InvalidForeignKey => e
        # class_name = /from table \"(?<table_name>[\p{L}_]*)\"/.match(e.message)[:table_name].singularize.camelcase
        # # pk_id = /from table \"(?<pk_id>[\p{L}_]*)\"/.match(e.message)[:pk_id].singularize.camelcase
        # clazz = Object.const_get class_name
        # objects = clazz.where(model.class.table_name.singularize => model)
        model_name = t("activerecord.models.#{model.class.name.underscore}")
        @error_message = "#{model_name} no se pudo borrar porque tiene elementos asociados."
        logger.debug e.message
      end
      false
    end

    def render_listing
      @collection = @collection.page(params[:page]).per(current_page_size)
    end

    def buscar_instancia
      if Object.const_defined?('FriendlyId') && @clase_modelo.is_a?(FriendlyId)
        @clase_modelo.friendly.find(params[:id])
      else
        @clase_modelo.find(params[:id])
      end
    end

    def set_instancia_modelo
      if action_name.in? %w[new create]
        self.instancia_modelo = @clase_modelo.new(modelo_params)
      else
        self.instancia_modelo = buscar_instancia

        instancia_modelo.assign_attributes(modelo_params) if action_name.in? %w[update]
      end

      instancia_modelo.current_user = send(PgEngine.configuracion.current_user_method)

      authorize instancia_modelo

      # TODO: problema en create y update cuando falla la validacion
      # Reproducir el error antes de arreglarlo
      self.instancia_modelo = instancia_modelo.decorate if action_name.in? %w[show edit new]
    end

    def instancia_modelo=(val)
      instance_variable_set(:"@#{nombre_modelo}", val)
    end

    def instancia_modelo
      instance_variable_get(:"@#{nombre_modelo}")
    end

    def modelo_params
      if action_name == 'new'
        params.permit(atributos_permitidos)
      else
        params.require(nombre_modelo).permit(atributos_permitidos)
      end
    end

    def nombre_modelo
      @clase_modelo.name.underscore
    end

    def clase_modelo
      # agarro la variable o intento con el nombre del controller
      @clase_modelo ||= self.class.name.singularize.gsub('Controller', '').constantize
    end

    def filtros_y_policy(campos)
      @filtros = PgEngine::FiltrosBuilder.new(
        self, clase_modelo, campos
      )
      scope = policy_scope(clase_modelo)

      @filtros.filtrar(scope)
    end

    def do_sort(scope, field, direction)
      unless scope.model.column_names.include? field.to_s
        PgLogger.warning("No existe el campo \"#{field}\"")
        return scope
      end
      scope = scope.order(field => direction)
      instance_variable_set(:@field, field)
      instance_variable_set(:@direction, direction)
      scope
    rescue ArgumentError => e
      PgLogger.warning(e.to_s)
      scope
    end

    def sort_collection(scope, options = {})
      if params[:order_by].present?
        field = params[:order_by]
        direction = params[:order_direction]
        do_sort(scope, field, direction)
      elsif options[:default].present?
        field = options[:default].first[0]
        direction = options[:default].first[1]
        do_sort(scope, field, direction)
      else
        scope
      end
    end
  end
end
