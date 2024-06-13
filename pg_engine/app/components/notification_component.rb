class NotificationComponent < BaseComponent
  def initialize(notification: nil)
    @notification = notification
    super
  end

  erb_template <<~ERB
    <div class="notification d-flex justify-content-between <%= 'unseen' if @notification.unseen? %>"
         id="<%= dom_id(@notification) %>" data-id="<%= @notification.id %>">
      <div>
        <%= @notification.message %>
      </div>
      <div class="notification--time text-body-tertiary text-end ms-4">
        hace
        <%= distance_of_time_in_words @notification.created_at, Time.zone.now %>
      </div>
    </div>
  ERB
end
