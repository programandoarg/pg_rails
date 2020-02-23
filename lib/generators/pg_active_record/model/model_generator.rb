require "rails/generators/active_record/model/model_generator"

module PgActiveRecord
  class ModelGenerator < ActiveRecord::Generators::ModelGenerator
    source_paths << File.expand_path('templates', __dir__)
  end
end
