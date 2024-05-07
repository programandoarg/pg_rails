# frozen_string_literal: true

# generado con pg_rails

class EmailDecorator < PgEngine::BaseDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def encoded_eml_link
    link_to 'Download', helpers.rails_blob_path(object.encoded_eml), target: :_blank, rel: :noopener
  end
end
