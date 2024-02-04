# frozen_string_literal: true

module PgRails
  class InstalarGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def copy_application_policy
      template 'pg_rails.rb', 'config/initializers/pg_rails.rb'
    end

    private

      def clase_aplicacion
        'cosa'
      end
  end
end
