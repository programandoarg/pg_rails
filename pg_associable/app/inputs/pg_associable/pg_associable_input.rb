# frozen_string_literal: true

module PgAssociable
  class PgAssociableInput < SimpleForm::Inputs::StringInput
    include ActionView::Helpers::FormTagHelper

    def hidden_input(wrapper_options = {})
      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
      # merged_input_options = merge_wrapper_options(merged_input_options, { class: 'oculto' })
      @builder.hidden_field(attribute_name, merged_input_options)
    end

    def input(wrapper_options = nil)
      unless string?
        input_html_classes.unshift('string')
        # input_html_options[:type] ||= input_type if html5?
      end
      input_html_options[:type] = 'text'

      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
      merged_input_options = merge_wrapper_options(merged_input_options, { class: 'keep-disabled' })

      text_field_tag(nil, object.send(reflection.name).to_s, merged_input_options)
    end

    def modal_link(wrapper_options = nil)
      "<a href=\"#{options[:url_modal]}\" class=\"modal-link d-inline-block\" data-turbo-stream style=\"position:absolute; left:0; right:0; top:0; bottom:0;\"></a>".html_safe
    end
    def limpiar(wrapper_options = nil)
      content_tag('a', href: 'javascript:void(0)', class: 'limpiar', title: 'Limpiar', tabindex: '0', data: { action: 'asociable#selectItem' }) { '<i class="bi bi-x-lg"></i>'.html_safe }
    end
    def pencil(wrapper_options = nil)
      '<i tabindex="-1" class="bi bi-pencil pencil"></i>'.html_safe
    end
  end
end
