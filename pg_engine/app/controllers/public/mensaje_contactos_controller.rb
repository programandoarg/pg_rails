# frozen_string_literal: true

# generado con pg_rails

module Public
  class MensajeContactosController < PublicController
    include PgEngine::Resource

    before_action { @clase_modelo = MensajeContacto }

    before_action(only: :index) { authorize MensajeContacto }

    before_action :set_instancia_modelo, only: %i[new create]

    layout 'pg_layout/container_logo'

    def new; end

    def create
      if Current.user.present?
        @mensaje_contacto.email = Current.user.email
        @mensaje_contacto.nombre = Current.user.nombre_completo
      end
      if @mensaje_contacto.save
        render turbo_stream: turbo_stream.update('mensaje_contacto', partial: 'gracias')
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def atributos_permitidos
      %i[nombre email telefono mensaje]
    end
  end
end
