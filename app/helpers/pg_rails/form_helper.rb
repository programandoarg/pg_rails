module PgRails
  module FormHelper
    def pg_form_for(object, *args, &block)
      options = args.extract_options!

      options[:builder] = PgFormBuilder
      options[:html] ||= {}
      if options[:html].key?(:class)
        options[:html][:class] = ['pg-form', options[:html][:class]].compact
      else
        options[:html][:class] = 'pg-form'
      end

      simple_nested_form_for(object, *(args << options), &block)
    end
  end
end
