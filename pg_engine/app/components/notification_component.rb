class NotificationComponent < BaseComponent
  def initialize(notification: nil)
    @notification = notification
    super
  end

  erb_template <<~ERB
    <div class="text-info-emphasis">
      <%= @notification.message %>
    </div>
  ERB
end
