# frozen_string_literal: true

module PgEngine
  # rubocop:disable Rails/ApplicationController
  class BaseController < ActionController::Base
    # rubocop:enable Rails/ApplicationController
    include Pundit::Authorization
    include PrintHelper
    include PostgresHelper
    include FlashHelper
    include RouteHelper
    include PgAssociable::Helpers

    class Redirect < PgEngine::Error
      attr_accessor :url

      def initialize(url)
        @url = url
        super
      end
    end

    protect_from_forgery with: :exception

    rescue_from StandardError, with: :internal_error
    rescue_from Pundit::NotAuthorizedError, with: :not_authorized
    rescue_from Redirect do |e|
      redirect_to e.url
    end

    def internal_error(error)
      pg_err error

      respond_to do |format|
        format.html do
          render InternalErrorComponent.alert_wrapped(view_context),
                  layout: 'pg_layout/centered'
        end
        format.turbo_stream do
          flash.now[:critical] = InternalErrorComponent.new.render_in(view_context)

          render turbo_stream: (turbo_stream.remove_all('.modal') + render_turbo_stream_flash_messages),
                 status: :internal_server_error
        end
        format.any do
          head :internal_server_error
        end
      end
    end

    before_action do
      Current.user = current_user
    end

    helper_method :dev_user_or_env?
    def dev_user_or_env?
      Rails.env.development? || dev_user?
    end

    helper_method :dev_user?
    def dev_user?
      Current.user&.developer?
    end

    helper_method :mobile_device?

    layout 'pg_layout/base'

    # Los flash_types resultantes serían:
    # [:critical, :alert, :notice, :warning, :success]
    add_flash_types :critical, :warning, :success

    before_action do
      console if dev_user_or_env? && (params[:show_web_console] || params[:wc])
    end

    before_action do
      @breakpoint_navbar_expand = 'md'
      navbar_expanded = cookies[:navbar_expand] != 'false'
      @navbar_opened_class = navbar_expanded ? 'opened' : ''
      @navbar_chevron_class = navbar_expanded ? 'bi-chevron-left' : 'bi-chevron-right'
      @navbar = Navbar.new(Current.user)

      if Rollbar.configuration.enabled && Rails.application.credentials.rollbar.present?
        @rollbar_token = Rails.application.credentials.rollbar.access_token_client
      end
    end

    def mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end

    def pundit_user
      Current.user
    end

    protected

    def not_authorized(_arg_required_for_active_admin)
      respond_to do |format|
        format.json do
          render json: { error: 'Acceso no autorizado' },
                 status: :unprocessable_entity
        end
        # TODO: responder a turbo_stream
        format.html do
          if request.path == root_path
            # TODO!: renderear un 500.html y pg_err
            sign_out(Current.user) if Current.user.present?
            render plain: 'Acceso no autorizado', status: :unprocessable_entity
          else
            go_back('Acceso no autorizado')
          end
        end
      end
    end

    def go_back(message = nil, type: :alert)
      flash[type] = message if message.present?
      redirect_back fallback_location: root_path
    end
  end
end
