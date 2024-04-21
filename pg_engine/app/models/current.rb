class Current < ActiveSupport::CurrentAttributes
  attribute :account, :user, :namespace
  # attribute :request_id, :user_agent, :ip_address

  # resets { Time.zone = nil }

  def user=(user)
    super
    self.account = user.current_account
    # Time.zone    = user.time_zone
  end
end
