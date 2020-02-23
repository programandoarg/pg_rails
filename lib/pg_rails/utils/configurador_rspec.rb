module PgRails
  class ConfiguradorRSpec
    def self.configurar(config)
      config.include FactoryBot::Syntax::Methods
      config.include Devise::Test::ControllerHelpers, type: :controller
      config.include Devise::Test::IntegrationHelpers, type: :request
      config.include ActiveSupport::Testing::TimeHelpers
      config.include SmartListing::Helper::ControllerExtensions, type: :view
      config.include SmartListing::Helper, type: :view
    end
  end
end

# esto es un monkey patch por el método smart_listing_config_profile
module SmartListing::Helper::ControllerExtensions
  def smart_listing_create *args
    options = args.extract_options!
    name = (args[0] || options[:name] || controller_name).to_sym
    collection = args[1] || options[:collection] || smart_listing_collection

    view_context = self.respond_to?(:controller) ? controller.view_context : self.view_context
    options = {:config_profile => view_context.try(:smart_listing_config_profile) }.merge(options)

    list = SmartListing::Base.new(name, collection, options)
    list.setup(params, cookies)

    @smart_listings ||= {}
    @smart_listings[name] = list

    list.collection
  end
end
