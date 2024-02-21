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
      klass = clase_asociacion(atributo)
      user = template.controller.current_user
      in_modal = self.options[:asociable].present?
      puede_crear = !in_modal && Pundit::PolicyFinder.new(klass).policy.new(user, klass).new?
      collection = Pundit::PolicyFinder.new(klass).scope.new(user, klass).resolve

      if collection.count <= MAXIMO_PARA_SELECT
        if puede_crear
          # TODO: si hay option preload, usar
          options.deep_merge!({ wrapper_html: { 'data-puede-crear': 'true' } })
          options.deep_merge!({ wrapper_html: { 'data-preload': collection.decorate.to_json } })
          options.deep_merge!({ wrapper_html: { data: { controller: 'asociable', 'asociable-modal-outlet': '.modal' } } })
          options[:as] = 'pg_associable'
          association atributo, options
        else
          options[:collection] = collection
          association atributo, options
        end
      else
        if puede_crear
          options.deep_merge!({ wrapper_html: { 'data-puede-crear': 'true' } })
        end

        if options[:preload].present?
          preload = options.delete(:preload)
          if preload.is_a? Integer
            collection = collection.limit(preload)
          else
            collection = preload
          end
          options.deep_merge!({ wrapper_html: { 'data-preload': collection.decorate.to_json } })
        end

        options.deep_merge!({ wrapper_html: { data: { controller: 'asociable', 'asociable-modal-outlet': '.modal' } } })
        options[:as] = 'pg_associable'
        association atributo, options
      end
    end

    def clase_asociacion(atributo)
      asociacion = object.class.reflect_on_all_associations.find { |a| a.name == atributo.to_sym }
      nombre_clase = asociacion.options[:class_name]
      nombre_clase = asociacion.name.to_s.camelize if nombre_clase.nil?
      Object.const_get(nombre_clase)
    end
  end
end
