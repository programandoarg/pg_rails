module PgAssociable
  module FormBuilderMethods
    def self.included(mod)
      mod.include Rails.application.routes.url_helpers
    end

    # TODO: no depender de :admin
    def pg_associable(atributo, options = {})
      asociacion = object.class.reflect_on_all_associations.find { |a| a.name == atributo.to_sym }
      nombre_clase = asociacion.options[:class_name]
      nombre_clase = asociacion.name.to_s.camelize if nombre_clase.nil?
      clase_asociacion = Object.const_get(nombre_clase)
      url_modal = polymorphic_url([:abrir_modal, :admin, clase_asociacion], only_path: true)
      options[:as] = 'pg_associable/pg_associable'
      options[:wrapper] = :pg_associable
      options[:url_modal] = url_modal
      association atributo, options
    end

    def pg_associable_inline(atributo, options = {})
      asociacion = object.class.reflect_on_all_associations.find { |a| a.name == atributo.to_sym }
      nombre_clase = asociacion.options[:class_name]
      nombre_clase = asociacion.name.to_s.camelize if nombre_clase.nil?
      clase_asociacion = Object.const_get(nombre_clase)
      url_search = polymorphic_url([:buscar, :admin, clase_asociacion], only_path: true)
      options[:as] = 'pg_associable/pg_associable_inline'
      options[:wrapper] = :pg_associable_inline
      options[:url_search] = url_search
      association atributo, options
    end
  end
end
