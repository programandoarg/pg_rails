# frozen_string_literal: true

# generado con pg_rails

module Admin
  class EmailsController < AdminController
    include PgEngine::Resource

    before_action { @clase_modelo = Email }

    before_action(only: :index) { authorize Email }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Email.nombre_plural, :admin_emails_path

    def new
      render template: 'admin/emails/_send', locals: { email: @email },
             layout: 'pg_layout/containerized'
    end

    def create
      saved = false
      ActiveRecord::Base.transaction do
        if (saved = @email.save)
          PgEngine::AdminMailer.with(email_object: @email).admin_mail.deliver_later
        end
      end
      if saved
        redirect_to @email.decorate.target_object
      else
        render template: 'admin/emails/_send',
               layout: 'pg_layout/containerized', status: :unprocessable_entity,
               locals: { email: @email }
      end
    end

    private

    def atributos_permitidos
      %i[status from_address from_name reply_to to subject body_input associated_id associated_type]
    end

    def atributos_para_buscar
      %i[accepted_at delivered_at opened_at from_address from_name reply_to to subject body_input tags
         message_id mailer status_detail status]
    end

    def atributos_para_listar
      %i[from_address to subject body_input tags associated status]
    end

    def atributos_para_mostrar
      %i[message_id status status_detail accepted_at delivered_at opened_at from_address
         from_name reply_to to subject body_input tags associated mailer encoded_eml_link]
    end
  end
end
