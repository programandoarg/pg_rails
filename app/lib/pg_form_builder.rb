# frozen_string_literal: true

# TODO: fix hackeo
# class PgFormBuilder < NestedForm::SimpleBuilder
class PgFormBuilder < SimpleForm::FormBuilder
  def mensajes_de_error
    return unless object.errors.present?

    errors = object.errors.full_messages.map { |m| "<li>#{m}</li>" }.join
    "<div class='alert alert-danger'>#{errors}</div>".html_safe
  end

  map_type :date, to: PgRails::FechaInput
  # map_type :datetime, to: PgRails::FechaInput

  def asociacion_creable(atributo, url_seleccionar, url_crear, options = {})
    options[:as] = 'pg_rails/asociacion_creable'
    options[:wrapper] = :asociacion_creable
    options[:url_seleccionar] = url_seleccionar
    options[:url_crear] = url_crear
    options[:wrapper_html] = { class: 'completado' } if object.send(atributo).present?
    association atributo, options
  end

  def submit_button(*args, &block)
    options = args.extract_options!.dup
    options[:class] = ['btn-primary', options[:class]].compact
    args << options
    send(:submit, *args, &block)
  end
end
