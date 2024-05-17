module PgEngine
  class BaseDecorator < PgEngine::BaseRecordDecorator
    class Deprecator
      def deprecation_warning(_deprecated_method_name, message, _caller_backtrace = nil)
        message = 'DEPRECACION WARNING: PgEngine::BaseDecorator is deprecated, mejor usá BaseRecordDecorator'
        Kernel.warn message
      end
    end

    class << self
      deprecate :decorate, deprecator: Deprecator.new
    end
  end
end
