# frozen_string_literal: true

module PgRails
  class ApplicationController < ActionController::Base
    include Pundit
    include SmartListing::Helper::ControllerExtensions
    helper  SmartListing::Helper
    include PrintHelper
    include PostgresHelper

    rescue_from PrintHelper::FechaInvalidaError, with: :fecha_invalida

    layout :setear_layout

    def self.inherited(klass)
      super
      # incluyo los helpers de /app/helpers de la main_app
      klass.helper :all
    end

    protected

      def pg_respond_update(object: nil, extra_js: nil)
        object ||= instancia_modelo
        respond_to do |format|
          if (@saved = object.save)
            format.html do
              redirect_to object.decorate.target_object, notice: "#{@clase_modelo.nombre_singular} actualizadx."
            end
            format.json { render json: object.decorate }
          else
            format.html { render :edit }
            format.json { render json: object.errors, status: :unprocessable_entity }
          end
          format.js do
            render '_cerrar_modal', locals: {
              contenido: 'form', extra_js: ['modal_ajax_form', extra_js]
            }
          end
        end
      end

      def pg_respond_create(object: nil, extra_js: nil)
        object ||= instancia_modelo
        respond_to do |format|
          if (@saved = object.save)
            format.html do
              redirect_to object.decorate.target_object, notice: "#{@clase_modelo.nombre_singular} creadx."
            end
            format.json { render json: object.decorate }
          else
            format.html { render :new }
            format.json { render json: object.errors.full_messages, status: :unprocessable_entity }
          end
          format.js do
            render '_cerrar_modal', locals: {
              contenido: 'form', extra_js: ['modal_ajax_form', extra_js]
            }
          end
        end
      end

      def pg_respond_index(collection)
        respond_to do |format|
          format.json { render json: collection }
          format.js { render_smart_listing }
          format.html { render_smart_listing }
          format.xlsx do
            render xlsx: 'download',
                   filename: "#{@clase_modelo.nombre_plural.gsub(' ', '-').downcase}" \
                             "-#{Date.today}.xlsx"
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
                redirect_to redirect_url, notice: 'Elemento borrado.'
              else
                redirect_back(fallback_location: root_path, notice: 'Elemento borrado.')
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
                flash[:error] = @error_message
                if redirect_url.present?
                  redirect_to redirect_url
                else
                  redirect_back(fallback_location: root_path)
                end
              end
            end
            format.json { render json: { error: @error_message }, status: :unprocessable_entity }
          end
        end
      end

      # destroy_and_respond DEPRECADO
      alias_method :destroy_and_respond, :pg_respond_destroy

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

      def render_smart_listing
        raise 'implementar en subclase'
      end

      def set_instancia_modelo
        if action_name.in? %w[new create]
          self.instancia_modelo = @clase_modelo.new(modelo_params)
        else
          self.instancia_modelo = @clase_modelo.find(params[:id])

          instancia_modelo.assign_attributes(modelo_params) if action_name.in? %w[update]
        end

        instancia_modelo.current_user = current_user

        authorize instancia_modelo

        self.instancia_modelo = instancia_modelo.decorate if action_name.in? %w[show new edit]
      end

      def instancia_modelo=(val)
        instance_variable_set("@#{nombre_modelo}".to_sym, val)
      end

      def instancia_modelo
        instance_variable_get("@#{nombre_modelo}".to_sym)
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

      def default_url_options(options = {})
        if Rails.env.production?
          options.merge(protocol: 'https')
        else
          options
        end
      end

      def setear_layout
        if params[:sin_layout] == 'true'
          false
        else
          'application'
        end
      end

      def clase_modelo
        # agarro la variable o intento con el nombre del controller
        @clase_modelo ||= self.class.name.singularize.gsub('Controller', '').constantize
      end

      def filtros_y_policy(campos)
        @filtros = PgRails::FiltrosBuilder.new(
          self, clase_modelo, campos
        )
        scope = policy_scope(clase_modelo)

        @filtros.filtrar(scope)
      end

      def smart_listing(smart_listing_key, scope, partial, options = {})
        options[:default_sort] = { id: :desc } unless options[:default_sort].present?
        options[:partial] = partial
        smart_listing_create smart_listing_key, scope, options

        return unless params["#{smart_listing_key}_smart_listing"].present?

        render partial: 'actualizar_smart_listing', locals: { smart_listing_key: smart_listing_key },
               layout: false, content_type: 'text/javascript'
      end

      def fecha_invalida
        respond_to do |format|
          format.json do
            render json: { error: 'Formato de fecha inválido' }, status: :unprocessable_entity
          end
          format.js { render inline: 'showToast("error", "Formato de fecha inválido")' }
          format.html { go_back('Formato de fecha inválido') }
        end
      end
  end
end
