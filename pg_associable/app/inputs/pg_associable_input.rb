# frozen_string_literal: true

class PgAssociableInput < SimpleForm::Inputs::StringInput
  include ActionView::Helpers::FormTagHelper

  def hidden_input(_wrapper_options = {})
    # merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    # merged_input_options = merge_wrapper_options(merged_input_options, { class: 'oculto' })
    @builder.hidden_field(attribute_name)
  end

  def input(wrapper_options = nil)
    unless string?
      input_html_classes.unshift('string')
    end
    input_html_options[:data] = { url: options[:url_search] }
    input_html_options[:type] = 'text'

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    content_tag('div', class: 'position-relative') do
      hidden_input + text_field_tag(nil, object.send(reflection.name).to_s, merged_input_options) + modal_link + limpiar + pencil
    end
  end

  def modal_link(_wrapper_options = nil)
    "<a href=\"#{options[:url_modal]}\" class=\"modal-link d-inline-block\" data-turbo-stream style=\"position:absolute; left:0; right:0; top:0; bottom:0;\"></a>".html_safe
  end

  def limpiar(_wrapper_options = nil)
    content_tag('a', href: 'javascript:void(0)', class: 'limpiar', title: 'Limpiar', tabindex: '0',
                     data: { action: 'asociable#selectItem' }) do
      '<i class="bi bi-x-lg"></i>'.html_safe
    end
  end

  def pencil(_wrapper_options = nil)
    '<i tabindex="-1" class="bi bi-pencil pencil"></i>'.html_safe
  end
end
