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

    protect_from_forgery with: :exception

    rescue_from PrintHelper::FechaInvalidaError, with: :fecha_invalida
    rescue_from Pundit::NotAuthorizedError, with: :not_authorized

    helper_method :mobile_device?

    layout 'pg_layout/layout'

    # Los flash_types resultantes serían:
    # [:alert, :notice, :warning, :success]
    add_flash_types :warning, :success

    before_action do
      @breakpoint_navbar_expand = 'md'
      @navbar_opened_class = if cookies[:navbar_expand] == 'false' || !user_signed_in?
                               ''
                             else
                               'opened'
                             end
      @navbar = Navbar.new(current_user)
    end

    def mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end

    protected

    def default_url_options(options = {})
      if Rails.env.production?
        options.merge(protocol: 'https')
      else
        options
      end
    end

    def fecha_invalida
      respond_to do |format|
        format.json do
          render json: { error: 'Formato de fecha inválido' },
                 status: :unprocessable_entity
        end
        format.html { go_back('Formato de fecha inválido') }
      end
    end

    def not_authorized
      respond_to do |format|
        format.json do
          render json: { error: 'Not authorized' },
                 status: :unprocessable_entity
        end
        format.html do
          if request.path == root_path
            render plain: 'Not authorized'
          else
            go_back('Not authorized')
          end
        end
      end
    end

    def go_back(message = nil, type: :alert)
      if message.present?
        flash[type] = message
      end
      redirect_back fallback_location: root_path
    end
  end
end
