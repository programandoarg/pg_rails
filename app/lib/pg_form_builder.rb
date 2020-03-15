class PgFormBuilder < NestedForm::SimpleBuilder
  def mensajes_de_error
    return unless object.errors.present?
    (
      "<div class='alert alert-danger'>" +
        object.errors.full_messages.map { |m| "<li>#{m}</li>" }.join +
        "</div>"
    ).html_safe
  end

  map_type :date, to: PgRails::FechaInput
  # map_type :datetime, to: PgRails::FechaInput

  def submit_button(*args, &block)
    options = args.extract_options!.dup
    options[:class] = ['btn-primary', options[:class]].compact
    args << options
    send(:submit, *args, &block)
  end
end
