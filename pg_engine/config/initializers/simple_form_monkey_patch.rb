module SimpleForm
  module Components
    module Errors
      def error_text
        begin
          if object.errors.details[attribute_name].map(&:values).flatten.include? :blank
            return
          end
        rescue StandardError => e
          pg_err e
        end
        text = has_custom_error? ? options[:error] : errors.reject(&:empty?).send(error_method)
        return if text.blank?

        "#{html_escape(options[:error_prefix])} #{html_escape(text)}".lstrip.html_safe
      end
    end
  end
end
