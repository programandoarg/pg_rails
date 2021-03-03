# frozen_string_literal: true

module PgRails
  class Filtros
    class << self
      # metodo facilitador para hacer queries sin
      # tener que crear un FiltrosBuilder
      def filtrar(scope, parametros)
        FiltrosBuilder.new(nil, scope.model, [:categorias_es_igual_a])
                      .filtrar(scope, parametros)
      end
    end
  end
end
