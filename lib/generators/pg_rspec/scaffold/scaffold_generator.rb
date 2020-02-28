require 'generators/rspec/scaffold/scaffold_generator'

module PgRspec
  module Generators
    class ScaffoldGenerator < Rspec::Generators::ScaffoldGenerator
      # agrego la carpeta para que busque templates
      # manteniendo la source_root de Rspec::Generators::ScaffoldGenerator
      # para poder copiar sólo los que quiero cambiar
      source_paths << File.expand_path('templates', __dir__)

      remove_hook_for :integration_tool, :as => :integration

      def generate_routing_spec
        # piso el método para que no genere nada
      end
    end
  end
end
