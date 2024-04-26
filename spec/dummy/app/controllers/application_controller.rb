class ApplicationController < PgEngine::BaseController
  include ActionView::Helpers::AssetTagHelper

  before_action do
    @navbar.logo = ApplicationController.render(
      partial: 'layouts/logo', locals: { image_url: 'logo-navbar-1.png', href: root_path }
    )
    @navbar.logo_xl_url = 'logo-xl-light.png'
    # @navbar.logo_xl = ApplicationController.render(
    #   partial: 'layouts/logo', locals: { image_url: 'facturabien.png', href: root_path }
    # )
  end
end
