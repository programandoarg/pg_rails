# frozen_string_literal: true

class AlertComponent < ViewComponent::Base
  def initialize(type:, toast: false, dismissible: true)
    @type = type.to_s
    @toast = toast
    @dismissible = dismissible
    @klass = [
      "alert-#{flash_type_to_class}",
      ('alert-dismissible' if @dismissible),
      ('position-absolute pg-toast' if @toast)
    ].join(' ')
    # TODO!: raise if type invalid?
  end

  def icon_class
    case @type
    when 'critical'
      "bi-emoji-dizzy me-3 fs-2"
      # "bi-exclamation-triangle-fill me-3 fs-2"
    when 'alert'
      "bi-exclamation-triangle-fill me-2"
    when 'warning'
      "bi-exclamation-circle me-2"
    when 'success'
      "bi-check-lg me-2"
    when 'notice'
      "bi-info-circle me-2"
    end
  end

  def flash_type_to_class
    case @type
    when 'notice'
      'info'
    when 'critical', 'alert'
      'danger'
    when 'warning'
      'warning'
    when 'success'
      'success'
    else
      @type
    end
  end
end
