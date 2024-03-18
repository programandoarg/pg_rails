module PgEngine
  module PgRailsHelper
    def dev?
      Rails.env.development? || current_user&.developer?
    end

    def current_account
      current_user&.current_account
    end

    def img_placeholder(src = nil, width: '100%', height: '100%', fade_in: false, **img_opts)
      if fade_in || src.nil?
        img_opts = img_opts.merge(style: [img_opts[:style],'display:none'].compact.join(';'))
        content_tag('div', class: 'placeholder-glow') do
          content_tag('div', class: 'placeholder', style: "width: #{width}; height: #{height}") do
            if src.present?
              image_tag src,
                        'data-controller': 'fadein_onload',
                        **img_opts
            end
          end
        end
      else
        image_tag src, **img_opts
      end
    end
  end
end
