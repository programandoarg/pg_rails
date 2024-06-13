module Users
  class NotificationsController < ApplicationController
    def mark_as_seen
      # No handleo errores porque no debería fallar, y si falla
      # se notifica a rollbar y al user no le pasa nada
      notifications = Noticed::Notification.where(id: params[:ids].split(','))
      notifications.each(&:mark_as_seen!)
      head :ok
    end
  end
end
