# frozen_string_literal: true

# require 'activesupport/time'
module ActiveSupport
  class TimeWithZone
    def to_s(format = :default)
      if format == :db
        utc.to_s(format)
      elsif formatter = ::Time::DATE_FORMATS[format] # rubocop:disable Lint/AssignmentInCondition
        formatter.respond_to?(:call) ? formatter.call(self).to_s : strftime(formatter)
      else
        # "#{time.strftime("%Y-%m-%d %H:%M:%S")} #{formatted_offset(false, 'UTC')}" # mimicking Ruby Time#to_s format
        time.strftime('%d/%m/%Y %H:%M')
      end
    end
  end
end
