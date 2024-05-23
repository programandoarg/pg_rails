require 'fileutils'
require 'mailgun'
require 'active_support'
require 'active_support/core_ext/numeric/time'
require 'json'

module PgEngine
  module Mailgun
    class LogSync
      def self.download # rubocop:disable Metrics/AbcSize
        domain = ENV.fetch('MAILGUN_DOMAIN')

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
          items.push(result.body['items'])
          # puts "Current: #{current}. Items count: #{result.body['items'].length}"
          current -= range

          break if current < start_time
        end

        FileUtils.mkdir_p(inbox_dir)

        items = items.flatten

        File.write("#{inbox_dir}/#{domain}_#{Time.zone.now.strftime('%Y-%m-%d_%H.%M.%S')}.json", items.to_json)
        items.each do |item|
          digest(item)
        end
      end

      def self.digest(item)
        message_id = item['message']['headers']['message-id']

        EmailLog.create!(
          email: Email.where(message_id:).first,
          log_id: item['id'],
          event: item['event'],
          log_level: item['log-level'],
          severity: item['severity'],
          timestamp: item['timestamp'],
          message_id:,
        )
      rescue StandardError => e
        pg_err e, item
      end

      def self.base_dir
        @base_dir ||= if Rails.env.test?
                        File.expand_path 'tmp/mailgun_logs', Rails.root
                      else
                        File.expand_path 'log/mailgun_logs', Rails.root
                      end
      end

      def self.inbox_dir
        @inbox_dir ||= File.expand_path 'inbox/', base_dir
      end
    end
  end
end
