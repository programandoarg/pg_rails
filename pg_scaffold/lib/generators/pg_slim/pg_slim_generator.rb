# frozen_string_literal: true

require 'generators/slim/scaffold/scaffold_generator'

class PgSlimGenerator < Slim::Generators::ScaffoldGenerator
  source_root File.expand_path('templates', __dir__)

  class_option :paranoia, type: :boolean, default: false, desc: 'Paranoid y deleted_at.'
  class_option :discard, type: :boolean, default: false, desc: 'Discard y discarded_at.'
  class_option :trackeo_de_usuarios, type: :boolean, default: true,
                                     desc: 'Genera campos creado_por y actualizado_por.'
  class_option :download_file, type: :boolean, default: false, desc: 'Archivo de download'
  class_option :index_file, type: :boolean, default: false, desc: 'Archivo de index'

  def copiar_download
    return unless options[:download_file]

    template 'download.xlsx.axlsx',
             File.join('app', 'views', controller_file_path, 'download.xlsx.axlsx')
  end

  protected

  def available_views
    if options[:index_file]
      %w[index show _form]
    else
      %w[show _form]
    end
  end
end
