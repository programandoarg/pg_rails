# frozen_string_literal: true

class PgScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  include Rails::Generators::ResourceHelpers

  class_option :orm, banner: 'NAME', type: :string, required: true,
                     desc: 'ORM to generate the controller for'

  class_option :decorator, type: :boolean, default: true,  desc: 'Generate view specs'

  class_option :paranoia, type: :boolean, default: false, desc: 'Paranoid y deleted_at.'
  class_option :discard, type: :boolean, default: false, desc: 'Discard y discarded_at.'
  class_option :trackeo_de_usuarios, type: :boolean, default: true,
                                     desc: 'Genera campos creado_por y actualizado_por.'

  argument :attributes, type: :array, default: [], banner: 'field:type field:type'

  def create_controller_files
    template 'controller.rb',
             File.join('app/controllers', controller_class_path,
                       "#{controller_file_name}_controller.rb")
  end

  hook_for :test_framework, as: :scaffold

  invoke :model
  invoke :resource_route
  invoke :pg_slim

  def decorator
    invoke :pg_decorator if options[:decorator]
  end

  invoke :pg_pundit

  def print_output
    puts "
!!! Agregar al locale: es.yml:
#{singular_table_name}:
  one: #{singular_table_name.titleize}
  other: #{plural_table_name.titleize}
"
  end

  private

    def atributos_a_filtrar
      attributes
    end
end
