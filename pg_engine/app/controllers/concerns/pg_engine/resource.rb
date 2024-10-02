module PgEngine
  module Resource
    # rubocop:disable Metrics/PerceivedComplexity
    def self.included(clazz)
      class << clazz
        # This is a per class variable, all subclasses of clazz inherit it
        # BUT **the values are independent between all of them**
        attr_accessor :nested_class, :nested_key, :clase_modelo

        # TODO: separar los endpoints de la lógica de filtros para evitar esta variable
        # en Agenda
        attr_accessor :skip_default_breadcrumb
      end
      clazz.delegate :nested_key, :nested_class, :clase_modelo, to: clazz

      clazz.helper_method :nested_class, :nested_key, :clase_modelo
      clazz.helper_method :nested_record, :nested_id

      clazz.helper_method :atributos_para_listar
      clazz.helper_method :atributos_para_mostrar
      clazz.helper_method :current_page_size
      clazz.helper_method :show_filters?
      clazz.helper_method :available_page_sizes
      clazz.helper_method :column_options_for

      clazz.before_action do
        # TODO: quitar esto, que se use el attr_accessor
        #       o sea, quitar todas las referencias a @clase_modelo
        @clase_modelo = clase_modelo
      end

      clazz.before_action unless: -> { clazz.skip_default_breadcrumb } do
        if nested_record.present?
          # Link al nested, siempre que sea no sea un embedded frame
          # ya que en tal caso se supone que el nested está visible
          # en el main frame. Además, si es un modal abierto desde
          # el nested record, no muestro el link al mismo.
          unless frame_embedded?
            if modal_targeted? && referred_by?(nested_record)
              add_breadcrumb nested_record.decorate.to_s_short
            else
              add_breadcrumb nested_record.decorate.to_s_short,
                             nested_record.decorate.target_object
            end
          end

          # Texto de index pero sin link, porque se supone que es un
          # embedded index o viene de tal
          add_breadcrumb clase_modelo.nombre_plural

        elsif !modal_targeted?
          # Link al index, siempre que no sea un modal, porque en tal
          # caso se supone que el index está visible en el main frame
          if clase_modelo.present?
            add_breadcrumb clase_modelo.nombre_plural,
                           url_for([pg_namespace, nested_record, clase_modelo])
          else
            # :nocov:
            pg_warn 'clase_modelo is nil'
            # :nocov:
          end
        end
      end

      clazz.layout :set_layout
    end
    # rubocop:enable Metrics/PerceivedComplexity

    def column_options_for(_object, _attribute)
      { class: 'text-nowrap' }
    end

    def referred_by?(object)
      url_for(object.decorate.target_object) == request.referer
    end

    def nested_id
      return unless nested_key.present? && nested_class.present?

      id = params[nested_key]

      # if using hashid-rails
      if nested_class.respond_to? :decode_id
        id = nested_class.decode_id(id)
      end

      id
    end

    def nested_record
      return if nested_id.blank?

      nested_class.find(nested_id)
    rescue ActiveRecord::RecordNotFound => e
      pg_warn(e)
      raise PgEngine::PageNotFoundError
    end

    def accepts_turbo_stream?
      request.headers['Accept'].present? &&
        request.headers['Accept'].include?('text/vnd.turbo-stream.html')
    end

    def respond_with_modal?
      can_open_modal? || modal_targeted?
    end

    def can_open_modal?
      request.get? &&
        clase_modelo.default_modal &&
        accepts_turbo_stream? &&
        !in_modal?
    end

    def set_layout
      if action_name == 'index'
        'pg_layout/base'
      else
        'pg_layout/containerized'
      end
    end

    # Public endpoints
    def abrir_modal
      pg_respond_abrir_modal
    end

    def buscar
      pg_respond_buscar
    end

    def index
      @collection = filtros_y_policy(atributos_para_buscar, default_sort)

      pg_respond_index
    end

    def show
      pg_respond_show
    end

    # FIXME: refactor
    def respond_with_modal(component)
      content = component.render_in(view_context)

      if can_open_modal?
        modal = ModalComponent.new.with_content(content)
        render turbo_stream: turbo_stream.append_all('body', modal)
      else
        render html: content
      end
    end

    def new
      if can_open_modal?
        path = [request.path, request.query_string].compact.join('?')
        component = ModalContentComponent.new(src: path)
        respond_with_modal(component)
      else
        add_breadcrumb instancia_modelo.submit_default_value
      end
    end

    def edit
      if can_open_modal?
        path = [request.path, request.query_string].compact.join('?')
        component = ModalContentComponent.new(src: path)
        respond_with_modal(component)
      else
        if modal_targeted? && referred_by?(instancia_modelo)
          add_breadcrumb instancia_modelo.to_s_short
        else
          add_breadcrumb instancia_modelo.to_s_short,
                         instancia_modelo.target_object
        end
        add_breadcrumb 'Modificando'
      end
    end

    def create
      pg_respond_create
    end

    def update
      pg_respond_update
    end

    def destroy
      pg_respond_destroy(instancia_modelo, params[:redirect_to])
    end
    # End public endpoints

    protected

    def default_sort
      'id desc'
    end

    def available_page_sizes
      [5, 10, 20, 30, 50, 100].push(current_page_size).uniq.sort
    end

    def show_filters_by_default?
      true
    end

    def filters_applied?
      params[RansackMemory::Core.config[:param].presence || :q].present?
    end

    def session_key_identifier
      ::RansackMemory::Core.config[:session_key_format]
                           .gsub('%controller_name%', controller_path.parameterize.underscore)
                           .gsub('%action_name%', action_name)
                           .gsub('%request_format%', request.format.symbol.to_s)
                           .gsub('%turbo_frame%', request.headers['Turbo-Frame'] || 'top')
      # FIXME: rename to main?
    end

    def show_filters?
      return true if filters_applied?

      idtf = "show-filters_#{session_key_identifier}"

      if params[:ocultar_filtros]
        session[idtf] = false
      elsif params[:mostrar_filtros]
        session[idtf] = true
      end

      if session[idtf].nil?
        show_filters_by_default?
      else
        session[idtf]
      end
    end

    def current_page_size
      aux = params[:page_size].presence&.to_i
      if aux.present? && aux.positive?
        session[page_size_session_key] = aux
      end

      session[page_size_session_key].presence || default_page_size
    end

    def page_size_session_key
      "page_size_#{session_key_identifier}"
    end

    def default_page_size
      10
    end

    def pg_respond_update
      object = instancia_modelo
      if (@saved = object.save)
        respond_to do |format|
          format.html do
            if params[:inline_attribute].present?
              render InlineShowComponent.new(object, params[:inline_attribute]), layout: false
            elsif in_modal?
              body = <<~HTML.html_safe
                <pg-event data-event-name="pg:record-updated" data-turbo-temporary
                  data-response='#{object.decorate.to_json}'></pg-event>
              HTML
              render html: ModalContentComponent.new.with_content(body)
                                                .render_in(view_context)
            else
              redirect_to object.decorate.target_object
            end
          end
          format.json do
            render json: object.decorate.as_json
          end
        end
      elsif params[:inline_attribute].present?
        render InlineEditComponent.new(object, params[:inline_attribute]),
               layout: false, status: :unprocessable_entity
      else
        add_breadcrumb instancia_modelo.decorate.to_s_short, instancia_modelo.decorate.target_object
        add_breadcrumb 'Modificando'
        # TODO: esto solucionaría el problema?
        # self.instancia_modelo = instancia_modelo.decorate
        #
        render :edit, status: :unprocessable_entity
      end
    end

    def pg_respond_create
      object = instancia_modelo
      if (@saved = object.save)
        if in_modal?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-created" data-turbo-temporary
              data-response='#{object.decorate.to_json}'></pg-event>
          HTML
          render turbo_stream: turbo_stream.append(current_turbo_frame, body)
        else
          redirect_to object.decorate.target_object
        end
      else
        add_breadcrumb instancia_modelo.decorate.submit_default_value
        # TODO: esto solucionaría el problema?
        # self.instancia_modelo = instancia_modelo.decorate

        render :new, status: :unprocessable_entity
      end
    end

    def pg_respond_index
      respond_to do |format|
        format.json { render json: @collection }
        format.html { render_listing }
        format.xlsx do
          render xlsx: 'download',
                 filename: "#{clase_modelo.nombre_plural.gsub(' ', '-').downcase}" \
                           "-#{Time.zone.now.strftime('%Y-%m-%d-%H.%M.%S')}.xlsx"
        end
      end
    end

    def pg_respond_show
      if can_open_modal?
        path = [request.path, request.query_string].compact.join('?')
        component = ModalContentComponent.new(src: path)
        respond_with_modal(component)
      else
        add_breadcrumb instancia_modelo.to_s_short, instancia_modelo.target_object
      end
    end

    def destroyed_message(model)
      "#{model.model_name.human} #{model.gender == 'f' ? 'borrada' : 'borrado'}"
    end

    # rubocop:disable Metrics/PerceivedComplexity
    def pg_respond_destroy(model, redirect_url = nil)
      if destroy_model(model)
        # FIXME: rename to main
        if turbo_frame? && current_turbo_frame != 'top'
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-destroyed" data-turbo-temporary>
            </pg-event>
          HTML
          render turbo_stream: turbo_stream.append(current_turbo_frame, body)
        elsif redirect_url.present?
          redirect_to redirect_url, notice: destroyed_message(model), status: :see_other
        elsif accepts_turbo_stream?
          body = <<~HTML.html_safe
            <pg-event data-event-name="pg:record-destroyed" data-turbo-temporary>
            </pg-event>
          HTML
          render turbo_stream: turbo_stream.append_all('body', body)
        else
          redirect_back(fallback_location: root_path,
                        notice: destroyed_message(model), status: 303)
        end
      elsif in_modal?

        flash.now[:alert] = @error_message
        render turbo_stream: render_turbo_stream_flash_messages(to: '.modal-body .flash')
      elsif accepts_turbo_stream?
        flash.now[:alert] = @error_message
        render turbo_stream: render_turbo_stream_flash_messages
      else
        flash[:alert] = @error_message
        redirect_back(fallback_location: root_path, status: 303)
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity

    def destroy_model(model)
      @error_message = 'No se pudo eliminar el registro'

      begin
        destroy_method = model.respond_to?(:discard) ? :discard : :destroy
        return true if model.send(destroy_method)

        @error_message = model.errors.full_messages.join(', ').presence || @error_message

        false
      rescue ActiveRecord::InvalidForeignKey => e
        model_name = t("activerecord.models.#{model.class.name.underscore}")
        @error_message = "#{model_name} no se pudo borrar porque tiene elementos asociados."
        pg_warn(e)
      end

      false
    end

    def render_listing
      total = @collection.count
      current_page = params[:page].presence&.to_i || 1
      if current_page_size * (current_page - 1) >= total
        current_page = (total.to_f / current_page_size).ceil
      end
      @collection = @collection.page(current_page).per(current_page_size)
      @records_filtered = default_scope_for_current_model.any? if @collection.empty?
    end

    def buscar_instancia
      if Object.const_defined?('FriendlyId') && clase_modelo.is_a?(FriendlyId)
        clase_modelo.friendly.find(params[:id])
      elsif clase_modelo.respond_to? :find_by_hashid!
        clase_modelo.find_by_hashid!(params[:id])
      else
        clase_modelo.find(params[:id])
      end
    rescue ActiveRecord::RecordNotFound
      raise PgEngine::PageNotFoundError
    end

    def set_instancia_modelo
      if action_name.in? %w[new create]
        self.instancia_modelo = clase_modelo.new(modelo_params)
        authorize(instancia_modelo)
        if nested_id.present?
          instancia_modelo.send("#{nested_key}=", nested_id)
        end
      else
        self.instancia_modelo = buscar_instancia
        authorize(instancia_modelo)
        instancia_modelo.assign_attributes(modelo_params) if action_name.in? %w[update]
      end

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
      clase_modelo.name.underscore
    end

    def filtros_y_policy(campos, dflt_sort = nil)
      @filtros = PgEngine::FiltrosBuilder.new(
        self, clase_modelo, campos
      )
      scope = policy_scope(clase_modelo)

      if nested_id.present?
        scope = scope.where(nested_key => nested_id)
        scope = scope.undiscarded if scope.respond_to?(:undiscarded)
      elsif scope.respond_to?(:kept)
        scope = scope.kept
      end
      # Soft deleted

      shared_context = Ransack::Adapters::ActiveRecord::Context.new(scope)
      @q = clase_modelo.ransack(params[:q], context: shared_context)
      @q.sorts = dflt_sort if @q.sorts.empty? && dflt_sort.present?

      shared_context.evaluate(@q)
    end

    def default_scope_for_current_model
      scope = policy_scope(clase_modelo)

      if nested_id.present?
        scope = scope.where(nested_key => nested_id)

        # Skip nested discarded check
        scope = scope.undiscarded if scope.respond_to?(:undiscarded)
      elsif scope.respond_to?(:kept)
        scope = scope.kept
      end
      # Soft deleted, including nested discarded check

      scope
    end
  end
end
