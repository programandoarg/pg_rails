module PgAssociable
  module Helpers
    def pg_respond_abrir_modal
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append_all('body', partial: 'pg_associable_modal')
        end
      end
    end

    # FIXME: policy scope, tal vez en query?
    def pg_respond_buscar
      partial = params[:partial] || 'pg_associable/resultados'
      collection = @clase_modelo.query(params[:query]).limit(6)
      render turbo_stream:
        turbo_stream.update("resultados-#{params[:id]}",
                            partial:, locals: { collection: })
    end
  end
end
