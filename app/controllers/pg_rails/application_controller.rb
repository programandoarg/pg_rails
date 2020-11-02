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

      def setear_layout
        if params[:sin_layout] == 'true'
          false
        else
          "application"
        end
      end

      def clase_modelo
        # agarro la variable o intento con el nombre del controller
        @clase_modelo ||= self.class.name.singularize.gsub('Controller', '').constantize
      end

      def filtros_y_policy(campos)
        @filtros = PgRails::FiltrosBuilder.new(
          self, clase_modelo, campos)
        scope = policy_scope(clase_modelo)
        if scope.respond_to?(:without_deleted)
          scope = scope.without_deleted
        end
        @filtros.filtrar(scope)
      end

      def smart_listing(smart_listing_key, scope, partial, options = {})
        unless options[:default_sort].present?
          options[:default_sort] = { id: :desc }
        end
        options[:partial] = partial
        smart_listing_create smart_listing_key, scope, options

        if params["#{smart_listing_key}_smart_listing"].present?
          render partial: 'actualizar_smart_listing', locals: { smart_listing_key: smart_listing_key },
                 layout: false, content_type: 'text/javascript'
        end
      end

      def destroy_and_respond(model, redirect_url = nil)
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

      def destroy_error_details_view
        'destroy_error_details'
      end

      def destroy_model(model)
        @error_message = 'No se pudo eliminar el registro'
        begin
          if model.destroy
            return true
          else
            @error_message = model.errors.full_messages.join(', ')
            return false
          end
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

      def fecha_invalida
        respond_to do |format|
          format.json { render json: { error: "Formato de fecha inválido" }, status: :unprocessable_entity }
          format.js { render inline: 'showToast("error", "Formato de fecha inválido")' }
          format.html { go_back('Formato de fecha inválido') }
        end
      end
  end
end
