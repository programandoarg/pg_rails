require __dir__ + '/../../app/helpers/pg_associable/helpers'
require __dir__ + '/../../app/helpers/pg_associable/form_builder_methods'

module PgAssociable
  class Engine < ::Rails::Engine
    isolate_namespace PgAssociable
    # initializer 'configurar_simple_form', after: 'factory_bot.set_fixture_replacement' do
    initializer 'configurar_simple_form' do
      require 'pg_associable/simple_form_initializer'

      if Rails.env.development?
        require 'byebug/core'
        begin
          Byebug.start_server 'localhost', ENV.fetch('BYEBUG_SERVER_PORT', 8989).to_i
        rescue Errno::EADDRINUSE
          Rails.logger.debug 'Byebug server already running'
        end
      end

    end
  end
end
