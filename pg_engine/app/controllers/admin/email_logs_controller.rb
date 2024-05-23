# frozen_string_literal: true

# generado con pg_rails

module Admin
  class EmailLogsController < AdminController
    include PgEngine::Resource

    before_action { @clase_modelo = EmailLog }

    before_action(only: :index) { authorize EmailLog }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb EmailLog.nombre_plural, :admin_email_logs_path

    private

    def atributos_permitidos
      %i[email_id log_id event log_level severity timestamp message_id]
    end

    def atributos_para_buscar
      %i[email log_id event log_level severity timestamp message_id]
    end

    def atributos_para_listar
      %i[email log_id event log_level severity timestamp message_id]
    end

    def atributos_para_mostrar
      %i[email log_id event log_level severity timestamp message_id]
    end
  end
end
