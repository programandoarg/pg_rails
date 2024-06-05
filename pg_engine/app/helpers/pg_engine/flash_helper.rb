module PgEngine
  module FlashHelper
    def render_turbo_stream_flash_messages
      turbo_stream.prepend 'flash', partial: 'pg_layout/flash'
    end

    def render_turbo_stream_title
      title = [breadcrumbs.last&.name, I18n.t('app_name')].compact.join(' - ')
      turbo_stream.update_all 'title', title
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
