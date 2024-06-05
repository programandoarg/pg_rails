class InternalErrorComponent < BaseComponent
  def initialize(error_msg: nil)
    @error_msg = error_msg
    super
  end

  def alert_type
    :critical
  end

  erb_template <<~ERB
    <div>
      <div class="mb-1">
        <%= @error_msg || 'Ocurrió algo inesperado' %>
      </div>
      Por favor, intentá nuevamente
      <br>
      o <a class="text-decoration-underline" href="<%= new_public_mensaje_contacto_path %>">dejá un mensaje</a>
      para que te avisemos
      <br>
      cuando el problema esté resuelto 🙏
    </div>
  ERB
end
