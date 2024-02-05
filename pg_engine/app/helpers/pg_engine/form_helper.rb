# frozen_string_literal: true

module PgEngine
  module FormHelper
    def pg_form_for(object, *args, &)
      if object.is_a? PgEngine::BaseDecorator
        object = object.target_object
      elsif object.is_a?(PgEngine::BaseRecord) &&
            object.decorator_class.present? &&
            object.decorator_class < PgEngine::BaseDecorator
        object = object.decorate.target_object
      end
      # byebug
      options = args.extract_options!

      options[:builder] = PgFormBuilder
      options[:html] ||= {}
      options[:html][:class] = if options[:html].key?(:class)
                                 ['pg-form', options[:html][:class]].compact
                               else
                                 'pg-form'
                               end

      simple_form_for(object, *(args << options), &)
    end

    def url_change_format(url, formato)
      uri = URI.parse(url)
      uri.path = "#{uri.path}.#{formato}"
      uri.to_s
    end
  end
end
