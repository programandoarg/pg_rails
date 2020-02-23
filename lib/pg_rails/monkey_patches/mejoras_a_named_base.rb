require 'rails/generators/named_base'

module Rails
  module Generators
    class NamedBase < Base
      private
        def ruta_vistas
          class_path.dup.push(plural_name).join('/')
        end
    end
  end
end
