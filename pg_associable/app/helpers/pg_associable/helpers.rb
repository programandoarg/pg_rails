module PgAssociable
  module Helpers
    MAX_RESULTS = 8

    def pg_respond_abrir_modal
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append_all('body', partial: 'pg_associable_modal')
        end
      end
    end

    def pg_respond_buscar
      partial = 'pg_associable/resultados_inline'
      resultados_prefix = 'resultados-inline'
      @collection = policy_scope(@clase_modelo).kept.query(params[:query]).limit(MAX_RESULTS)
      render turbo_stream:
        turbo_stream.update("#{resultados_prefix}-#{params[:id]}",
                            partial:, locals: { collection: @collection })
    end
  end
end
