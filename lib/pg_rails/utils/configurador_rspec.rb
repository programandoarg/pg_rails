# frozen_string_literal: true

module PgRails
  class ConfiguradorRSpec
    def self.configurar(config)
      puts 'DEPRECADO: ConfiguradorRSpec'
      config.include FactoryBot::Syntax::Methods
      config.include Devise::Test::ControllerHelpers, type: :controller
      config.include Devise::Test::IntegrationHelpers, type: :request
      config.include Warden::Test::Helpers
      config.include ActiveSupport::Testing::TimeHelpers
    end
  end
end
