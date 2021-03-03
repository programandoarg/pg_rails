# frozen_string_literal: true

require 'rails/generators/named_base'

module Rails
  module Generators
    class NamedBase < Base
      def nombre_clase_completo
        if namespaced?
          (namespaced_class_path + [file_name]).map!(&:camelize).join('::')
        else
          (regular_class_path + [file_name]).map!(&:camelize).join('::')
        end
      end

      def nombre_tabla_completo_singular
        if namespaced?
          (namespaced_class_path + [singular_name]).join('_')
        else
          (regular_class_path + [singular_name]).join('_')
        end
      end

      private

        def ruta_vistas
          if namespaced?
            namespaced_class_path.dup.push(plural_name).join('/')
          else
            regular_class_path.dup.push(plural_name).join('/')
          end
        end
    end
  end
end
