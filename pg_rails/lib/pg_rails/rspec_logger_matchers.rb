# :nocov:
module PgEngine
  module Matchers
    module PgLogger
      class Base < RSpec::Rails::Matchers::BaseMatcher
        def initialize(text, level)
          @text = text
          @level = level
        end
      end

      class PgHaveLogged < Base
        def matches?(proc)
          unless Proc === proc
            raise ArgumentError, "have_logged only support block expectations"
          end

          original_logged_messages = Set.new(PgEngine::PgLogger.test_logged_messages)
          proc.call
          logged_messages = Set.new(PgEngine::PgLogger.test_logged_messages)

          @new_messages = logged_messages - original_logged_messages
          @new_messages.any? do |level, message|
            if @text.present? && @level.present?
              level == @level && message.include?(@text)
            elsif @text.present?
              message.include? @text
            elsif @level.present?
              level == @level
            else
              true
            end
          end
        end

        def failure_message
          "expected to #{@level || log}".tap do |msg|
            msg << "with text: #{@text}" if @text.present?
          end.tap do |msg|
            if @new_messages.any?
              msg << "\nLogged messages:"
              @new_messages.each do |level, message|
                msg << "\n  #{level}: #{message[0..200]}"
              end
            end
          end
        end

        def supports_block_expectations?
          true
        end
      end
    end

    def have_errored(text = nil)
      PgLogger::PgHaveLogged.new(text, :error)
    end

    def have_warned(text = nil)
      PgLogger::PgHaveLogged.new(text, :warn)
    end
  end
end
# :nocov:

