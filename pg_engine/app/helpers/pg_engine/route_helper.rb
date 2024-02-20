# frozen_string_literal: true

module PgEngine
  module RouteHelper
    class NamespaceDeductor
      def self.request(context)
        if context.respond_to?(:request) && context.request
          # Controllers
          context.request
        elsif context.respond_to?(:helpers) && context.helpers
          # Decorators
          context.helpers.request
        elsif context.respond_to?(:template) && context.template
          # FormBuilders
          context.template.request
        end
      end

      def self.namespace(context)
        req = request(context)
        route = Rails.application.routes.recognize_path(req.path)
        parts = route[:controller].split('/')
        return unless parts.length > 1

        parts.first.to_sym
      rescue ActionController::RoutingError
        nil
      end
    end

    def pg_namespace
      NamespaceDeductor.namespace(self)
    end

    def namespaced_path(object, options = {})
      target = [pg_namespace, object]
      if options[:prefix]
        target.prepend options[:prefix]
        options.delete(:prefix)
      end
      if options[:suffix]
        target.append options[:suffix]
        options.delete(:suffix)
      end
      target = target.flatten.compact
      options.merge!(only_path: true)
      polymorphic_url(target, options)
    end
  end
end
