module PgRails
  class ApplicationRecord < ActiveRecord::Base
    extend Enumerize
    include PrintHelper
    include PostgresHelper

    self.abstract_class = true

    attr_accessor :current_user

    before_create :setear_creado_y_actualizado_por
    before_update :setear_actualizado_por

    def to_s
      [:nombre, :name].each do |campo|
        if try(campo).present?
          return send(campo)
        end
      end
      super
    end

    private
      def setear_creado_y_actualizado_por
        setear_si_existe :creado_por, current_user
        setear_si_existe :actualizado_por, current_user
      end

      def setear_actualizado_por
        setear_si_existe :actualizado_por, current_user
      end

      def setear_si_existe(campo, valor)
        metodo = "#{campo}="
        if respond_to?(metodo) && valor.present?
          send(metodo, valor)
        end
      end
  end
end
