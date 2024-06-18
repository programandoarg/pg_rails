class PageNotFoundComponent < BaseComponent
  def alert_wrapped(view_context)
    AlertComponent.new(type: alert_type, dismissible: false)
                  .with_content(render_in(view_context))
  end

  def alert_type
    :warning
  end

  erb_template <<~ERB
    <div>
      <div class="mb-1">
        La página que buscás no existe
      </div>
    </div>
  ERB
end
