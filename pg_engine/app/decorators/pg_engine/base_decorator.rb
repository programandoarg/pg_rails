module PgEngine
  class BaseDecorator < PgEngine::BaseRecordDecorator
    class Deprecator
      def deprecation_warning(_deprecated_method_name, _message, _caller_backtrace = nil)
        Kernel.warn 'DEPRECACION WARNING: PgEngine::BaseDecorator is deprecated, mejor usá BaseRecordDecorator'
      end
    end

    class << self
      deprecate :decorate, deprecator: Deprecator.new
    end
  end
end
