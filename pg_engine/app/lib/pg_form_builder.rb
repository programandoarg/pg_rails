# frozen_string_literal: true

class PgFormBuilder < SimpleForm::FormBuilder
  include PgAssociable::FormBuilderMethods

  def mensajes_de_error
    errors_to_show = object.errors[:base]
    message = if errors_to_show.present?
                errors_to_show.map { |m| "#{m}" }.join('<br>')
              end

    error_notification(message: message)
  end

  map_type :date, to: PgEngine::FechaInput
  # map_type :datetime, to: PgEngine::FechaInput

  def submit_button(*args, &)
    options = args.extract_options!.dup
    options[:class] = ['btn-primary', options[:class]].compact
    args << options
    send(:submit, *args, &)
  end
end
