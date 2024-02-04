require __dir__ + '/../../app/helpers/pg_associable/helpers'
require __dir__ + '/../../app/helpers/pg_associable/form_builder_methods'

module PgAssociable
  class Engine < ::Rails::Engine
    isolate_namespace PgAssociable
    # initializer 'configurar_simple_form', after: 'factory_bot.set_fixture_replacement' do
    initializer 'configurar_simple_form' do
      require 'pg_associable/simple_form_initializer'
    end
  end
end
