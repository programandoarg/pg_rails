class BaseComponent < ViewComponent::Base
  def self.alert_wrapped(view_context)
    AlertComponent.new(type: alert_type)
                  .with_content(new.render_in(view_context))
  end

  def self.alert_type
    raise 'implement in subclass'
  end
end
