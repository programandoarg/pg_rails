# frozen_string_literal: true

require 'generators/rspec/model/model_generator'

module PgRspec
  module Generators
    class ModelGenerator < Rspec::Generators::ModelGenerator
      # agrego la carpeta para que busque templates
      # manteniendo la source_root de Rspec::Generators::ScaffoldGenerator
      # para poder copiar sólo los que quiero cambiar
      source_paths << File.expand_path('templates', __dir__)

      remove_hook_for :fixture_replacement

      invoke 'pg_factory_bot:model'

      # Esto quizas no es necesario
      def namespace
        nil
      end

      # :doc:
      def class_path
        []
      end

      def create_module_file; end
    end
  end
end
