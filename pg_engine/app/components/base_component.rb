class BaseComponent < ViewComponent::Base
  def alert_wrapped(view_context)
    AlertComponent.new(type: alert_type)
                  .with_content(render_in(view_context))
  end

  def alert_type
    # :nocov:
    raise 'implement in subclass'
    # :nocov:
  end
end
