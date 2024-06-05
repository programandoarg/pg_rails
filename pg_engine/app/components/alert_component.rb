# frozen_string_literal: true

class AlertComponent < ViewComponent::Base
  def initialize(type:, toast: false, dismissible: true)
    @type = type.to_s
    unless @type.in? ApplicationController._flash_types.map(&:to_s)
      raise PgEngine::Error, 'el type no es válido'
    end

    @toast = toast
    @dismissible = dismissible
    @klass = [
      "alert-#{flash_type_to_class}",
      ('alert-dismissible' if @dismissible),
      ('position-absolute pg-toast' if @toast)
    ].join(' ')

    super
  end

  def icon_class
    {
      'critical' => 'bi-emoji-dizzy me-3 fs-2',
      'alert' => 'bi-exclamation-triangle-fill me-2',
      'warning' => 'bi-exclamation-circle me-2',
      'success' => 'bi-check-lg me-2',
      'notice' => 'bi-info-circle me-2'
    }[@type]
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
      # :nocov:
      pg_err 'no debería pasar'
      # :nocov:
    end
  end
end
