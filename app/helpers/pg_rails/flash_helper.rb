module PgRails
  module FlashHelper
    def render_turbo_stream_flash_messages
      turbo_stream.prepend 'flash', partial: 'layouts/flash'
    end

    def render_turbo_stream_title
      turbo_stream.update 'title', "#{breadcrumbs.last&.name} - #{Rails.application.class.module_parent_name}"
    end
  end
end
