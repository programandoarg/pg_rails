# frozen_string_literal: true

class PgFormBuilder < SimpleForm::FormBuilder
  include PgAssociable::FormBuilderMethods
  include PgEngine::ErrorHelper

  def mensajes_de_error
    errors_to_show = object.errors[:base]
    message = (errors_to_show.map(&:to_s).join('<br>') if errors_to_show.present?)

    error_notification(message:)
  end

  def mensaje
    scope = error_message_for(object, associations:)
    return if scope.blank?

    I18n.t("simple_form.error_notification.#{scope}")
  end

  def associations
    object.class.reflect_on_all_associations
          .select { |a| a.instance_of? ActiveRecord::Reflection::HasManyReflection }
          .map(&:name)
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
