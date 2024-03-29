# frozen_string_literal: true

require 'rails/generators/active_record/model/model_generator'

module PgActiveRecord
  class ModelGenerator < ActiveRecord::Generators::ModelGenerator
    source_paths << File.expand_path('templates', __dir__)

    class_option :paranoia, type: :boolean, default: false, desc: 'Paranoid y deleted_at.'
    class_option :discard, type: :boolean, default: false, desc: 'Discard y discarded_at.'
    class_option :trackeo_de_usuarios, type: :boolean, default: true,
                                       desc: 'Genera campos creado_por y actualizado_por.'
    class_option :activeadmin, type: :boolean, default: false, desc: 'ActiveAdmin file'

    def create_activeadmin_file
      return unless options[:activeadmin]

      template 'admin.rb',
               File.join('app/admin', "#{table_name}.rb")
    end

    # :doc:
    def namespace
      nil
    end

    # :doc:
    def class_path
      []
    end

    def create_module_file; end
  end
end
