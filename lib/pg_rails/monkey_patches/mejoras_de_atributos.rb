# frozen_string_literal: true

require 'rails/generators'
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
              [Regexp.last_match(1), { limit: Regexp.last_match(2).to_i }]
            when /(string|text|binary|float|integer|date|datetime)\{(.+)\}/
              type = Regexp.last_match(1)
              provided_options = Regexp.last_match(2).split(/[,.-]/)
              options = provided_options.map { |opt| [opt.to_sym, true] }.to_h
              [type, options]
            when /decimal\{(\d+)[,.-](\d+)\}/
              [:decimal, { precision: Regexp.last_match(1).to_i, scale: Regexp.last_match(2).to_i }]
            when /(references|belongs_to)\{(.+)\}/
              type = Regexp.last_match(1)
              provided_options = Regexp.last_match(2).split(/[,.-]/)
              options = provided_options.map { |opt| parsear_opcion(opt) }.to_h

              # si es referencia le mando índice siempre
              options[:index] = true
              [type, options]
            else
              [type, {}]
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
        return name.camelize unless tiene_nombre_de_clase_explicito?

        @attr_options[:clase].gsub('/', '::')
      end

      # def tiene_modulo?
      #   @attr_options[:modulo].present?
      # end

      def tiene_nombre_de_clase_explicito?
        @attr_options[:clase].present?
      end

      # def tiene_tabla?
      #   @attr_options[:tabla].present?
      # end

      def es_enum?
        @attr_options[:enum].present?
      end

      def tabla_referenciada_singular
        return singular_name unless tiene_nombre_de_clase_explicito?

        @attr_options[:clase].gsub('/', '').underscore
      end

      def tabla_referenciada
        return plural_name unless tiene_nombre_de_clase_explicito?

        @attr_options[:clase].gsub('/', '').underscore.pluralize
      end

      # pisa geneators/rspec
      def input_type
        @input_type ||= if type == :text
                          'textarea'
                        elsif es_enum? || type == :references
                          'select'
                        else
                          'input'
                        end
      end

      def required?
        attr_options[:required]
      end

      private

        def options_for_migration
          @attr_options.dup.tap do |options|
            if required?
              options.delete(:required)
              options[:null] = false
            end

            if reference? && !polymorphic? && !tiene_nombre_de_clase_explicito?
              options[:foreign_key] =
                true
            end
            # options.delete(:modulo)
            # options.delete(:tabla)
            options.delete(:clase)
          end
        end
    end
  end
end
