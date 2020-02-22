require 'generators/slim/scaffold/scaffold_generator'

class PgSlimGenerator < Slim::Generators::ScaffoldGenerator
  source_root File.expand_path('templates', __dir__)

  def copiar_download
    template "download.xlsx.axlsx", File.join('app', 'views', controller_file_path, "download.xlsx.axlsx")
  end

  protected
    def available_views
      ['index', 'edit', 'show', 'new', '_form', '_listing']
    end
end
