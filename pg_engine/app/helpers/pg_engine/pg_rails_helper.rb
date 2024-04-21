module PgEngine
  module PgRailsHelper
    def current_account
      Current.user&.current_account
    end

    def img_placeholder(src: nil, width: '100%', height: '100%', fade_in: false, **img_opts)
      if fade_in || src.nil?
        img_opts = img_opts.merge(style: [img_opts[:style], 'display:none'].compact.join(';'))
        do_placeholder(src, width:, height:, **img_opts)
      else
        image_tag src, **img_opts
      end
    end

    private

    def do_placeholder(src = nil, width: '100%', height: '100%', **img_opts)
      content_tag('div', class: 'placeholder-glow', style: "width: #{width}; height: #{height}") do
        content_tag('div', class: 'placeholder w-100 h-100') do
          if src.present?
            image_tag src,
                      'data-controller': 'fadein_onload',
                      **img_opts
          end
        end
      end
    end
  end
end
