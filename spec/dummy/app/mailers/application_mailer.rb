class ApplicationMailer < PgEngine::BaseMailer
  before_action do
    @footer_image_alt = 'PgRails'
    @footer_href = root_url
  end
end
