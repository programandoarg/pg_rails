# frozen_string_literal: true

require 'rainbow'

# TODO: poder pasar blocks

def pg_err(*args)
  if ENV.fetch('RAISE_ERRORS', false)
    # :nocov:
    raise args.first if args.first.is_a?(Exception)

    raise StandardError, args

    # :nocov:
  end

  byebug if ENV.fetch('BYEBUG_ERRORS', false) # rubocop:disable Lint/Debugger

  pg_log(:error, *args)
end

def pg_warn(*args)
  pg_log(:warn, *args)
end

def pg_info(*args)
  pg_log(:info, *args)
end

def pg_debug(*args)
  pg_log(:debug, *args)
end

def pg_log(*args)
  PgEngine::PgLogger.log(*args)
end

module PgEngine
  class PgLogger
    class << self
      def log(type, *args)
        notify_all(build_msg(*args), type)
      end

      private

      def notify_all(mensaje, type)
        send_to_logger(mensaje, type)
        send_to_rollbar(mensaje, type)
        send_to_stdout(mensaje, type) if ENV.fetch('LOG_TO_STDOUT', nil)
        nil
      end

      # Senders

      def send_to_stdout(mensaje, type)
        puts rainbow_wrap(mensaje, type)
      end

      def send_to_rollbar(mensaje, type)
        Rollbar.send(type, mensaje)
        # Rollbar.send(type, "#{mensaje}\n\n#{bktrc.join("\n")}")
      rescue StandardError => e
        send_to_logger("Error notifying Rollbar #{e}", :error)
      end

      def send_to_logger(mensaje, type)
        Rails.logger.send(type, rainbow_wrap(mensaje, type))
      end

      # Format

      # TODO: loguear time
      def build_msg(*args)
        first = args.first
        if first.is_a?(Exception) && first.backtrace.present?
          <<~STR
            #{titulo(*args)}
            Exception Backtrace:
              #{cleaner.clean(first.backtrace).join("\n")}
            Caller Backtrace:
              #{cleaner.clean(caller).join("\n")}
          STR
        else
          <<~STR
            #{titulo(*args)}
            Caller Backtrace:
              #{cleaner.clean(caller).join("\n")}
          STR
        end
      rescue StandardError
        send_to_logger('ERROR: PgLogger error building msg', :error)
      end

      def titulo(*args)
        args.map { |obj| "#{obj.inspect} (#{obj.class})" }.join("\n")
      end

      def rainbow_wrap(mensaje, type)
        Rainbow(mensaje).bold.send(color_for(type))
      end

      def color_for(type)
        case type
        when :info
          :blue
        when :warn
          :yellow
        when :debug
          :orange
        else # :error
          :red
        end
      end

      # Backtrace helpers

      def cleaner
        bc = ActiveSupport::BacktraceCleaner.new
        bc.remove_silencers!
        pattern = /\A[^\/]+ \([\w.]+\) /
        bc.add_silencer { |line| pattern.match?(line) && !line.match?(/pg_contable|pg_rails/) }
        bc.add_silencer { |line| /pg_logger/.match?(line) }
        bc
      end
    end
  end
end
