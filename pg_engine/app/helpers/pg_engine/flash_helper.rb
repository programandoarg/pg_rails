module PgEngine
  module FlashHelper
    def render_turbo_stream_flash_messages
      turbo_stream.prepend 'flash', partial: 'pg_layout/flash'
    end

    def render_turbo_stream_title
      # rubocop:disable Rails/SkipsModelValidations
      turbo_stream.update_all 'title', "#{breadcrumbs.last&.name} - #{Rails.application.class.module_parent_name}"
      # rubocop:enable Rails/SkipsModelValidations
    end

    def flash_type_to_class(flash_type)
      case flash_type
      when 'notice'
        'info'
      when 'alert'
        'danger'
      when 'warning'
        'warning'
      when 'success'
        'success'
      else
        flash_type
      end
    end
  end
end
