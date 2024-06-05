class BadRequestComponent < BaseComponent
  def alert_type
    :alert
  end

  erb_template <<~ERB
    <div>
      <div class="mb-1">
        Solicitud incorrecta
      </div>
      Por favor, recargá la página e intentá nuevamente
      <br>
      o <a class="text-decoration-underline" href="<%= new_public_mensaje_contacto_path %>">ponete en contacto con nosotros</a>
    </div>
  ERB
end
