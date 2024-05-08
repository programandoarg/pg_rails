class ApplicationMailer < PgEngine::BaseMailer
  before_action do
    @footer_image_alt = 'PgRails'
  end
end
