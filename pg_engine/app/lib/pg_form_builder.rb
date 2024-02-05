# frozen_string_literal: true

class PgFormBuilder < SimpleForm::FormBuilder
  include PgAssociable::FormBuilderMethods

  def mensajes_de_error
    errors_to_show = object.errors[:base]
    return if errors_to_show.blank?

    errors = errors_to_show.map { |m| "<li>#{m}</li>" }.join
    "<div class='alert alert-danger'>#{errors}</div>".html_safe
  end

  map_type :date, to: PgRails::FechaInput
  # map_type :datetime, to: PgRails::FechaInput

  def submit_button(*args, &)
    options = args.extract_options!.dup
    options[:class] = ['btn-primary', options[:class]].compact
    args << options
    send(:submit, *args, &)
  end
end
