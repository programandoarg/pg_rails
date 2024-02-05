# frozen_string_literal: true

# TODO: fix hackeo
# class PgFormBuilder < NestedForm::SimpleBuilder
class PgFormBuilder < SimpleForm::FormBuilder
  include PgAssociable::FormBuilderMethods

  def mensajes_de_error
    return unless object.errors.present?

    errors = object.errors[:base].map { |m| "<li>#{m}</li>" }.join
    "<div class='alert alert-danger'>#{errors}</div>".html_safe
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
