module PgAssociable
  module FormBuilderMethods
    def self.included(mod)
      mod.include Rails.application.routes.url_helpers
      mod.include PgEngine::RouteHelper
    end

    def pg_associable(atributo, options = {})
      url_modal = namespaced_path(clase_asociacion(atributo), prefix: :abrir_modal)
      options[:as] = 'pg_associable/pg_associable'
      options[:wrapper] = :pg_associable
      options[:url_modal] = url_modal
      association atributo, options
    end

    def pg_associable_inline(atributo, options = {})
      url_search = namespaced_path(clase_asociacion(atributo), prefix: :buscar)
      options[:as] = 'pg_associable/pg_associable_inline'
      options[:wrapper] = :pg_associable_inline
      options[:url_search] = url_search
      association atributo, options
    end

    def clase_asociacion(atributo)
      asociacion = object.class.reflect_on_all_associations.find { |a| a.name == atributo.to_sym }
      nombre_clase = asociacion.options[:class_name]
      nombre_clase = asociacion.name.to_s.camelize if nombre_clase.nil?
      Object.const_get(nombre_clase)
    end
  end
end
