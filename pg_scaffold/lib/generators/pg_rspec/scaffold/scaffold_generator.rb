# frozen_string_literal: true

require 'generators/rspec/scaffold/scaffold_generator'

module PgRspec
  module Generators
    class ScaffoldGenerator < Rspec::Generators::ScaffoldGenerator
      # agrego la carpeta para que busque templates
      # manteniendo la source_root de Rspec::Generators::ScaffoldGenerator
      # para poder copiar sólo los que quiero cambiar
      source_paths << File.expand_path('templates', __dir__)

      class_option :paranoia, type: :boolean, default: false, desc: 'Paranoid y deleted_at.'
      class_option :discard, type: :boolean, default: false, desc: 'Discard y discarded_at.'
      class_option :trackeo_de_usuarios, type: :boolean, default: true,
                                         desc: 'Genera campos creado_por y actualizado_por.'

      class_option :controller_specs, type: :boolean, default: true
      class_option :request_specs,    type: :boolean, default: false
      class_option :view_specs,       type: :boolean, default: false

      # remove_hook_for :integration_tool, as: :integration
      # remove_hook_for :fixture_replacement

      def generate_routing_spec
        # piso el método para que no genere nada
      end

      protected

        def referencias_requeridas
          attributes.select { |at| at.reference? && at.required? }
        end

        def merge_referencias
          return unless referencias_requeridas.present?

          asd = referencias_requeridas.map { |r| "#{r.name}_id: #{r.name}.id" }
          ".merge(#{asd.join(', ')})"
        end
    end
  end
end
