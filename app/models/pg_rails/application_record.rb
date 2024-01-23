# frozen_string_literal: true

module PgRails
  class ApplicationRecord < ActiveRecord::Base
    extend Enumerize
    include PrintHelper
    include PostgresHelper

    self.abstract_class = true

    attr_accessor :current_user

    before_create :setear_creado_y_actualizado_por
    before_update :setear_actualizado_por

    def self.nombre_plural
      model_name.human(count: 2)
    end

    def self.nombre_singular
      model_name.human(count: 1)
    end

    def to_s
      %i[nombre name].each do |campo|
        return send(campo) if try(campo).present?
      end
      if id.present?
        "#{self.class.nombre_singular} ##{id}"
      else
        super
      end
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
        send(metodo, valor) if respond_to?(metodo) && valor.present?
      end
  end
end
