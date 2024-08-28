module PgEngine
  module FrameHelper
    def using_modal?
      controller.instance_variable_get(:@using_modal) ||
        controller.in_modal? || modal_targeted?
    end

    def in_modal?
      request.headers['Modal-Opened'] == 'true'
    end

    def current_turbo_frame
      request.headers['Turbo-Frame']
    end

    def turbo_frame?
      current_turbo_frame.present?
    end

    def modal_targeted?
      current_turbo_frame == 'modal_content'
    end

    def frame_embedded?
      turbo_frame? && current_turbo_frame.include?('embedded')
    end

    def embed_index(object, key)
      content_tag(:div, 'data-controller': 'embedded-frame') do
        turbo_frame_tag "embedded--#{key}",
                        refresh: :morph, src: url_for([pg_namespace, object, key]) do
          content_tag(:p, class: 'p text-body-secondary text-center') { 'Cargando...' }
        end
      end
    end
  end
end
