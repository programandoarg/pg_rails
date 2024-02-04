# frozen_string_literal: true

require 'rails/generators/active_record/model/model_generator'

module PgActiveRecord
  class ModelGenerator < ActiveRecord::Generators::ModelGenerator
    source_paths << File.expand_path('templates', __dir__)

    class_option :paranoia, type: :boolean, default: false, desc: 'Paranoid y deleted_at.'
    class_option :discard, type: :boolean, default: false, desc: 'Discard y discarded_at.'
    class_option :trackeo_de_usuarios, type: :boolean, default: true,
                                       desc: 'Genera campos creado_por y actualizado_por.'

    def namespace # :doc:
      nil
    end
    def class_path # :doc:
      []
    end
    def create_module_file
    end
  end
end
