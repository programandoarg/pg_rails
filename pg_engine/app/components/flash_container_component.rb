class FlashContainerComponent < ViewComponent::Base
  erb_template <<~HTML
    <div id="flash-container" class="d-flex justify-content-around sticky-top">
      <div id="flash" class="flash position-relative w-100 d-flex justify-content-center">
        <%= content || render(partial: 'pg_layout/flash') %>
      </div>
    </div>
  HTML
end
