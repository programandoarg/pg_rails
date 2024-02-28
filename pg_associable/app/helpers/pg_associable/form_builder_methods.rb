# TODO: mover a form_builder
module PgAssociable
  module FormBuilderMethods
    def self.included(mod)
      mod.include Rails.application.routes.url_helpers
      mod.include PgEngine::RouteHelper
    end

    MAXIMO_PARA_SELECT = 10
    # TODO: si está entre 10 y 50, habilitar un buscador por js

    def pg_associable(atributo, options = {})
      return input(atributo, options) if options[:disabled]

      collection, puede_crear = collection_pc(atributo, options)
      options.deep_merge!({ wrapper_html: { 'data-puede-crear': 'true' } }) if puede_crear

      if !puede_crear && collection.count <= MAXIMO_PARA_SELECT
        select_comun(atributo, options, collection)
      else
        select_pro(atributo, options, collection)
      end
    end

    def collection_pc(atributo, _options)
      klass = clase_asociacion(atributo)
      user = template.controller.current_user
      in_modal = options[:asociable].present?
      puede_crear = !in_modal && Pundit::PolicyFinder.new(klass).policy.new(user, klass).new?
      collection = Pundit::PolicyFinder.new(klass).scope.new(user, klass).resolve
      [collection, puede_crear]
    end

    def select_pro(atributo, options, collection)
      if (preload = options.delete(:preload))
        collection = preload.is_a?(Integer) ? collection.limit(preload) : preload
        options.deep_merge!({ wrapper_html: { 'data-preload': collection.decorate.to_json } })
      end
      # TODO: usar una clase más precisa para el modal?
      options.deep_merge!({ wrapper_html: { data: { controller: 'asociable',
                                                    'asociable-modal-outlet': '.modal' } } })
      options[:as] = 'pg_associable'
      association atributo, options
    end

    def select_comun(atributo, options, collection)
      options[:collection] = collection
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
