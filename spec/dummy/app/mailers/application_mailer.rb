class ApplicationMailer < PgEngine::BaseMailer

  LOGO_FOOTER = 'footer-mail-dark-light.png'.freeze

  before_action do
    png_data = File.read(File.expand_path("app/assets/images/#{LOGO_FOOTER}", Rails.root))
    attachments.inline[LOGO_FOOTER] = png_data
    @footer_href = "http://localhost:3000/?m=asd"
    @footer_image_src = attachments[LOGO_FOOTER].url
    @footer_image_alt = 'PgRails'
  end
end
