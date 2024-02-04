# frozen_string_literal: true

# este generator tiene que llamarse ModelGenerator para que funcione el hook_to
# del ModelGenerator de rails

require 'generators/factory_bot/model/model_generator'

module PgFactoryBot
  module Generators
    class ModelGenerator < FactoryBot::Generators::ModelGenerator
      # piso el método de FactoryBot::Generators::Base con el método original
      # de Rails::Generators::Base

      # rubocop:disable Naming/MemoizedInstanceVariableName
      def self.source_root(path = nil)
        @_source_root = path if path
        @_source_root ||= default_source_root
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName

      source_root File.expand_path('templates', __dir__)

      class_option(
        :dir,
        type: :string,
        default: 'spec/factories',
        desc: 'The directory or file root where factories belong'
      )

      # Los modelos nunca tienen modulo
      def explicit_class_option
      end

      def namespace # :doc:
        nil
      end
      def class_path # :doc:
        []
      end
      def create_module_file
      end

      private

#{factory_attributes.gsub(/^/, '    ')}#{los_traits.gsub(/^/, '    ')}
        def factory_definition
<<~RUBY
  factory :#{singular_table_name}#{explicit_class_option} do
#{factory_attributes}#{los_traits}
  end
RUBY
        end

        def los_traits
          ret = attributes.select(&:reference?).map do |atributo|
            {
              clase: atributo.clase_con_modulo,
              atributo_name: atributo.name,
            }
          end
        end

        # Genero los valores de las factories con los helpers de Faker

        def factory_attributes
          attributes.map do |attribute|
            if attribute.reference?
              # "association :#{attribute.name}, factory: :#{attribute.tabla_referenciada_singular}"
              attribute.name
            else
              "#{attribute.name} { #{valor_atributo(attribute)} }"
            end
          end
        end

        def valor_atributo(attribute)
          if attribute.es_enum?
            "#{nombre_clase_completo}.#{attribute.name}.values.sample"
          elsif attribute.type == :string
            'Faker::Lorem.sentence'
          elsif attribute.type == :date
            'Faker::Date.backward'
          elsif attribute.type == :float || attribute.type == :decimal
            'Faker::Number.decimal(l_digits: 3, r_digits: 2)'
          elsif attribute.type == :integer
            'rand(1..9999)'
          else
            attribute.default.inspect
          end
        end
    end
  end
end
