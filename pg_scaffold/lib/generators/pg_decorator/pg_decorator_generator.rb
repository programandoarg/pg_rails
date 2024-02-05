# frozen_string_literal: true

require 'generators/rails/decorator_generator'

class PgDecoratorGenerator < Rails::Generators::DecoratorGenerator
  source_root File.expand_path('templates', __dir__)

  remove_hook_for :test_framework

  # :doc:
  def namespace
    nil
  end

  # :doc:
  def class_path
    []
  end

  def create_module_file; end

  private

  def class_path_original
    @class_path.first
  end

  def parent_class_name
    'PgEngine::BaseDecorator'
  end
end
