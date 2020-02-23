require 'pg_rails/monkey_patches/quitar_rspec_a_generator_de_policies'

class PgScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  include Rails::Generators::ResourceHelpers

  class_option :orm, banner: "NAME", type: :string, required: true,
                     desc: "ORM to generate the controller for"

  class_option :decorator, type: :boolean, default: true,  :desc => "Generate view specs"

  argument :attributes, type: :array, default: [], banner: "field:type field:type"

  def create_controller_files
    template "controller.rb", File.join("app/controllers", controller_class_path, "#{controller_file_name}_controller.rb")
  end

  invoke :model
  invoke :resource_route
  invoke :pg_slim

  def decorator
    if options[:decorator]
      invoke :pg_decorator
    end
  end

  invoke 'pundit:policy'

  private

  def atributos_a_filtrar
    attributes
  end
end
