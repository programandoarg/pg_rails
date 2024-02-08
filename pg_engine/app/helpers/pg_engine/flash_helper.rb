module PgEngine
  module FlashHelper
    def render_turbo_stream_flash_messages
      turbo_stream.prepend 'flash', partial: 'layouts/flash'
    end

    def render_turbo_stream_title
      turbo_stream.update_all 'title', "#{breadcrumbs.last&.name} - #{Rails.application.class.module_parent_name}"
    end

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
  end
end
