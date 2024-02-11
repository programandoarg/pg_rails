# frozen_string_literal: true

# generado con pg_rails

class UserDecorator < PgEngine::BaseDecorator
  delegate_all

  def default_module
    :admin
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
