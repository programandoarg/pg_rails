require 'fileutils'
require 'mailgun'
require 'active_support'
require 'active_support/core_ext/numeric/time'
require 'json'

module PgEngine
  module Mailgun
    class LogSync
      def self.download # rubocop:disable Metrics/AbcSize
        key = Rails.application.credentials.dig(:mailgun, :api_key)
        mg_client = ::Mailgun::Client.new(key)
        items = []
        end_time = DateTime.now
        start_time = DateTime.now - 3.days
        range = 1.day
        current = end_time - range

        loop do
          get = "#{domain}/events?begin=#{current.to_i}&end=#{(current + range).to_i}&limit=300"
          result = mg_client.get(get)
          result.to_h!
          items.push(*result.body['items'])
          current -= range

          break if current < start_time
        end

        write_log(items)

        items.map do |item|
          digest(item)
        end.compact
      end

      def self.digest(item)
        message_id = item['message']['headers']['message-id']

        return if EmailLog.exists?(log_id: item['id'])

        EmailLog.create!(
          email: Email.where(message_id:).first,
          log_id: item['id'],
          event: item['event'],
          log_level: item['log-level'],
          severity: item['severity'],
          timestamp: item['timestamp'],
          message_id:
        )
      rescue StandardError => e
        pg_err e, item
      end

      def self.write_log(items)
        FileUtils.mkdir_p(log_dir)
        File.write("#{log_dir}/#{domain}_#{Time.zone.now.strftime('%Y-%m-%d_%H.%M.%S')}.json", items.to_json)
      end

      def self.domain
        ENV.fetch('MAILGUN_DOMAIN')
      end

      def self.log_dir
        @log_dir ||= if Rails.env.test?
                       File.expand_path 'tmp/mailgun_logs', Rails.root
                     else
                       # :nocov:
                       File.expand_path 'log/mailgun_logs', Rails.root
                       # :nocov:
                     end
      end
    end
  end
end
