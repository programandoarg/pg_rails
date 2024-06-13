module Users
  class NotificationsController < ApplicationController
    def mark_as_seen
      # FIXME: handle errors
      notifications = Noticed::Notification.where(id: params[:ids].split(','))
      notifications.each(&:mark_as_seen!)
      head :ok
    end
  end
end
