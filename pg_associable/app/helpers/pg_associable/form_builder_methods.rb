module PgAssociable
  module FormBuilderMethods
    def self.included(mod)
      mod.include Rails.application.routes.url_helpers
      mod.include PgEngine::RouteHelper
    end

    def pg_associable(atributo, options = {})
      options[:as] = 'pg_associable'
      options[:wrapper_html] = { data: { controller: 'asociable', 'asociable-modal-outlet': '.modal' } }
      association atributo, options
    end
  end
end
