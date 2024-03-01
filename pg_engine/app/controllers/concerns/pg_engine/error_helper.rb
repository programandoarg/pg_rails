module PgEngine
  module ErrorHelper
    extend ActiveSupport::Concern

    def merge_association_errors(details, assoc_key)
      details = details.except(assoc_key)
      assoc_items = object.send(assoc_key).map(&:errors).map(&:details)
      merged = assoc_items.inject({}) { |acc, el| acc.merge(el) }
      merged = merged.transform_values { |errs| errs.pluck(:error) }
      details.merge(merged)
    end

    def error_types(object, associations: [])
      details = object.errors.details.transform_values do |errs|
        errs.pluck(:error)
      end
      associations.each do |assoc_key|
        next unless details.key? assoc_key

        details = merge_association_errors(details, assoc_key)
      end
      details.values.flatten.uniq
    end

    def error_message_for(object, associations: [])
      types = error_types(object, associations:)

      if types == [:blank]
        :only_presence_errors
      elsif types.include? :blank
        :multiple_error_types
      elsif types.present?
        :not_presence_errors
      end
    end
  end
end
