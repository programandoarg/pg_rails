module SimpleForm
  module Components
    module Errors
      def error_text
        text = has_custom_error? ? options[:error] : errors.reject(&:empty?).send(error_method)
        return if text.blank?

        "#{html_escape(options[:error_prefix])} #{html_escape(text)}".lstrip.html_safe
      end
    end
  end
end
