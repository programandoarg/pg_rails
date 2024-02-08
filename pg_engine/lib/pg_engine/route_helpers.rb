module PgEngine
  module RouteHelpers
    def pg_resource(key)
      resources(key) do
        collection do
          get :abrir_modal
          post :buscar
        end
      end
    end
  end
end
