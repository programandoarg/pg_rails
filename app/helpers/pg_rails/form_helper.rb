# frozen_string_literal: true

module PgRails
  module FormHelper
    def pg_form_for(object, *args, &block)
      options = args.extract_options!

      options[:builder] = PgFormBuilder
      options[:html] ||= {}
      options[:html][:class] = if options[:html].key?(:class)
                                 ['pg-form', options[:html][:class]].compact
                               else
                                 'pg-form'
                               end

      simple_form_for(object, *(args << options), &block)
    end

    def url_change_format(url)
      uri = URI.parse(url)
      uri.path = "#{uri.path}.xlsx"
      uri.to_s
    end
  end
end
