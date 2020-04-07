module PgRails
  class AsociacionCreableInput < SimpleForm::Inputs::StringInput
    include ActionView::Helpers::FormTagHelper

    def boton(wrapper_options = {})
      button_tag('', wrapper_options)
    end
    def hidden_input(wrapper_options = {})
      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
      merged_input_options = merge_wrapper_options(merged_input_options, { class: 'oculto' })
      @builder.text_field(attribute_name, merged_input_options)
    end

    def input(wrapper_options = nil)
      unless string?
        input_html_classes.unshift("string")
        input_html_options[:type] ||= input_type if html5?
      end

      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

      text_field_tag(nil, object.send(reflection.name).to_s, merged_input_options)
    end

    def seleccionar_asociado(wrapper_options = {})
      icon = content_tag :span, nil, class: 'fa fa-hand-pointer'
      merged_input_options = merge_wrapper_options(wrapper_options, { class: 'seleccionar_asociado dropdown-item', href: 'javascript:void(0)', data: { url: options[:url_seleccionar] } })
      content_tag :a, "#{icon} Seleccionar".html_safe, merged_input_options
    end

    def crear_asociado(wrapper_options = {})
      icon = content_tag :span, nil, class: 'fa fa-plus-square'
      merged_input_options = merge_wrapper_options(wrapper_options, { class: 'crear_asociado dropdown-item', href: 'javascript:void(0)', data: { url: options[:url_crear] } })
      content_tag :a, "#{icon} Crear".html_safe, merged_input_options
    end

    def borrar_seleccion(wrapper_options = {})
      icon = content_tag :span, nil, class: 'fa fa-trash'
      merged_input_options = merge_wrapper_options(wrapper_options, { class: 'borrar_seleccion dropdown-item', href: 'javascript:void(0)' })
      content_tag :a, "#{icon} Borrar selección".html_safe, merged_input_options
    end
  end
end
