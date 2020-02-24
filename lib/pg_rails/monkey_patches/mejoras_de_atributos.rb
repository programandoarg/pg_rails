require 'rails/generators/generated_attribute'
require 'generators/rspec'

module Rails
  module Generators
    class GeneratedAttribute # :nodoc:
      class << self
        private

        def parse_type_and_options(type)
          case type
          when /(string|text|binary|integer)\{(\d+)\}/
            return $1, limit: $2.to_i
          when /(string|text|binary|integer)\{(.+)\}/
            type = $1
            provided_options = $2.split(/[,.-]/)
            options = Hash[provided_options.map { |opt| [opt.to_sym, true] }]
            return type, options
          when /decimal\{(\d+)[,.-](\d+)\}/
            return :decimal, precision: $1.to_i, scale: $2.to_i
          when /(references|belongs_to)\{(.+)\}/
            type = $1
            provided_options = $2.split(/[,.-]/)
            options = Hash[provided_options.map { |opt| parsear_opcion(opt) }]

            # si es referencia le mando índice siempre
            options[:index] = true
            return type, options
          else
            return type, {}
          end
        end

        def parsear_opcion(opcion)
          partes = opcion.split('=')
          if partes.count == 2
            [partes[0].to_sym, partes[1]]
          else
            [opcion.to_sym, true]
          end
        end
      end

      def clase_con_modulo
        "#{@attr_options[:modulo].camelize}::#{name.camelize}"
      end

      def tiene_modulo?
        @attr_options[:modulo].present?
      end

      def tabla_referenciada_singular
        return singular_name unless tiene_modulo?
        "#{@attr_options[:modulo]}_#{singular_name}"
      end

      def tabla_referenciada
        return plural_name unless tiene_modulo?
        "#{@attr_options[:modulo]}_#{plural_name}"
      end

      # pisa geneators/rspec
      def input_type
        @input_type ||= if type == :text
                          "textarea"
                        elsif type == :references
                          "select"
                        else
                          "input"
                        end
      end

      private

      def options_for_migration
        @attr_options.dup.tap do |options|
          if required?
            options.delete(:required)
            options[:null] = false
          end

          if reference? && !polymorphic? && !tiene_modulo?
            options[:foreign_key] = true
          end
          options.delete(:modulo)
        end
      end
    end
  end
end
