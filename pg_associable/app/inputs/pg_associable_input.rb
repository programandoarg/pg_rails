# frozen_string_literal: true

class PgAssociableInput < SimpleForm::Inputs::StringInput
  include ActionView::Helpers::FormTagHelper
  include Rails.application.routes.url_helpers
  include PgEngine::RouteHelper

  def hidden_input(_wrapper_options = {})
    @builder.hidden_field(attribute_name)
  end

  def controller
    # Para que no rompa polymorphic_url en NamespaceDeductor
  end

  def input(wrapper_options = nil)
    atributo = attribute_name.to_s.gsub('_id', '')
    url_modal = namespaced_path(clase_asociacion(atributo), prefix: :abrir_modal)
    url_search = namespaced_path(clase_asociacion(atributo), prefix: :buscar)

    input_html_options[:data] = { url_search:, url_modal: }
    input_html_options[:type] = 'text'

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    build_input(merged_input_options)
  end

  def clase_asociacion(atributo)
    asociacion = object.class.reflect_on_all_associations.find { |a| a.name == atributo.to_sym }
    nombre_clase = asociacion.options[:class_name]
    nombre_clase = asociacion.name.to_s.camelize if nombre_clase.nil?
    Object.const_get(nombre_clase)
  end

  def build_input(input_options)
    content_tag('div', class: 'position-relative') do
      hidden_input + text_field_tag(nil, object.send(reflection.name).to_s,
                                    input_options) + limpiar + pencil
    end
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
