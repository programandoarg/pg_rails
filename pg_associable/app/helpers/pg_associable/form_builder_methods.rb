# TODO: mover a form_builder
module PgAssociable
  module FormBuilderMethods
    def self.included(mod)
      mod.include Rails.application.routes.url_helpers
      mod.include PgEngine::RouteHelper
    end

    MAXIMO_PARA_SELECT = 10
    # TODO: si está entre 10 y 50, habilitar un buscador por js

    def pg_associable_pro(atributo, options = {})
      return input(atributo, options) if options[:disabled]

      select_pro(atributo, options, nil)
    end

    def pg_associable(atributo, options = {})
      # Si es new y tiene el nested asignado, no permito que se modifique
      # porque de todos modos se pisaría en el create
      if !object.persisted? &&
         template.nested_record.present? &&
         object.send(atributo) == (template.nested_record)
        options[:disabled] = true
      end

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
      user = Current.user
      puede_crear = !template.using_modal? && Pundit::PolicyFinder.new(klass).policy.new(user, klass).new?
      collection = Pundit::PolicyFinder.new(klass).scope.new(user, klass).resolve
      collection = collection.kept if collection.respond_to?(:kept)
      [collection, puede_crear]
    end

    def select_pro(atributo, options, collection)
      if (preload = options.delete(:preload))
        collection = preload.is_a?(Integer) ? collection.limit(preload) : preload
        options.deep_merge!({ wrapper_html: { 'data-preload': collection.decorate.to_json } })
      end
      # TODO: usar una clase más precisa para el modal?
      #       quizás sea este el motivo por el cual no funciona el multimodal
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

      raise PgEngine::Error, "no existe la asociación para el atributo: #{atributo}" if asociacion.blank?

      nombre_clase = asociacion.options[:class_name]
      nombre_clase = asociacion.name.to_s.camelize if nombre_clase.nil?
      Object.const_get(nombre_clase)
    end
  end
end
