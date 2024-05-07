# frozen_string_literal: true

# generado con pg_rails

module Admin
  class EmailsController < AdminController
    include PgEngine::Resource

    before_action { @clase_modelo = Email }

    before_action(only: :index) { authorize Email }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy content_eml]

    add_breadcrumb Email.nombre_plural, :admin_emails_path

    def content_eml
      send_data @email.content_eml, filename: "email_#{@email.id}.txt", disposition: :inline
    end

    private

    def atributos_permitidos
      %i[from_address from_name reply_to to subject body_input associated_id associated_type]
    end

    def atributos_para_buscar
      %i[accepted_at delivered_at opened_at from_address from_name reply_to to subject body_input tags content_eml
         message_id mailer status_detail status]
    end

    def atributos_para_listar
      %i[from_address to subject body_input tags associated status]
    end

    def atributos_para_mostrar
      %i[message_id status status_detail accepted_at delivered_at opened_at from_address
         from_name reply_to to subject body_input tags associated mailer content_eml_link]
    end
  end
end
