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

      # este método es igual al de FactoryBot::Generators::Base
      # pero si no lo pongo acá pone las clases sin el prefijo del módulo
      def explicit_class_option
        return if nombre_clase_completo == singular_table_name.camelize

        ", class: '#{nombre_clase_completo}'"
      end

      private

        def factory_definition
          <<~RUBY
              factory :#{singular_table_name}#{explicit_class_option} do
            #{factory_attributes.gsub(/^/, '    ')}

            #{los_traits.gsub(/^/, '    ')}
              end

          RUBY
        end

        def los_traits
          attributes.select(&:reference?).map do |atributo|
            <<~RUBY
              trait :#{atributo.name}_existente do
                #{atributo.name} { nil }
                #{atributo.name}_id { #{atributo.clase_con_modulo}.all.pluck(:id).sample }
              end
            RUBY
          end.join("\n")
        end

        # Genero los valores de las factories con los helpers de Faker

        def factory_attributes
          attributes.map do |attribute|
            if attribute.reference?
              "association :#{attribute.name}, factory: :#{attribute.tabla_referenciada_singular}"
            else
              "#{attribute.name} { #{valor_atributo(attribute)} }"
            end
          end.join("\n")
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
          else
            attribute.default.inspect
          end
        end
    end
  end
end
