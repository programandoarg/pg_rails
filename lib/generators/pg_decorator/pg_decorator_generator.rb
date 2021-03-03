# frozen_string_literal: true

require 'generators/rails/decorator_generator'

class PgDecoratorGenerator < Rails::Generators::DecoratorGenerator
  source_root File.expand_path('templates', __dir__)

  remove_hook_for :test_framework

  private

    def parent_class_name
      'PgRails::BaseDecorator'
    end
end
