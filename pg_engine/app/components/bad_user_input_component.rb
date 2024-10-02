# TODO: rename to WarningComponent or sth
class BadUserInputComponent < BaseComponent
  def initialize(error_msg:)
    @error_msg = error_msg
    super
  end

  def alert_type
    :warning
  end

  erb_template <<~ERB
    <div>
      <%= @error_msg %>
    </div>
  ERB
end
