# frozen_string_literal: true

module PgAssociable
  class PgAssociableInlineInput < SimpleForm::Inputs::StringInput
    include ActionView::Helpers::FormTagHelper

    def hidden_input(wrapper_options = {})
      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
      # merged_input_options = merge_wrapper_options(merged_input_options, { class: 'oculto' })
      @builder.hidden_field(attribute_name, merged_input_options)
    end

    def search_form(wrapper_options = nil)
      unless string?
        input_html_classes.unshift('string')
        # input_html_options[:type] ||= input_type if html5?
      end
      input_html_options[:type] = 'text'
      input_html_options[:data] = { url: options[:url_search] }
      input_html_options[:class] = 'form-control'
      input_html_options[:placeholder] = ''

      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

      text_field_tag(nil, object.send(reflection.name).to_s, merged_input_options)
    end

    def limpiar(_wrapper_options = nil)
      content_tag('a', href: 'javascript:void(0)', class: 'limpiar', title: 'Limpiar', tabindex: '0',
                       data: { action: 'asociable_inline#selectItem' }) do
        '<i class="bi bi-x-lg"></i>'.html_safe
      end
    end

    def pencil(_wrapper_options = nil)
      '<i tabindex="-1" class="bi bi-pencil pencil"></i>'.html_safe
    end
  end
end
