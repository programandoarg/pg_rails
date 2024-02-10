# frozen_string_literal: true

# require 'generators/rails/resource_route/resource_route_generator'

class PgResourceRouteGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  # Properly nests namespaces passed into a generator
  #
  #   $ bin/rails generate resource admin/users/products
  #
  # should give you
  #
  #   namespace :admin do
  #     namespace :users do
  #       resources :products
  #     end
  #   end
  def add_resource_route
    return if options[:actions].present?

    route_s = <<~RUBY
      pg_resource(:#{file_name.pluralize})
    RUBY
    route route_s, namespace: regular_class_path
  end
end
