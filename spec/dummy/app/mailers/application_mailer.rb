class ApplicationMailer < PgEngine::BaseMailer
  before_action do
    @footer_href = 'http://localhost:3000/?m=asd'
    @footer_image_alt = 'PgRails'
  end
end
