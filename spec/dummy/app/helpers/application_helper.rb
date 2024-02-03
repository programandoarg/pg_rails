module ApplicationHelper
  # rubocop:disable Metrics/MethodLength
  def flash_type_to_class(flash_type)
    case flash_type
    when 'notice'
      'info'
    when 'error'
      'danger'
    when 'alert'
      'warning'
    when 'success'
      'success'
    else
      flash_type
    end
  end
  # rubocop:enable Metrics/MethodLength
end
