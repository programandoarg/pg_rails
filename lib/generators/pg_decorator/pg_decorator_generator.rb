class PgDecoratorGenerator < Rails::Generators::DecoratorGenerator
  source_root File.expand_path('templates', __dir__)

  private

  def parent_class_name
    "SlimSmartListingRails::BaseDecorator"
  end
end
