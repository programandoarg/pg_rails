require 'fileutils'
require 'mailgun'
require 'active_support'
require 'active_support/core_ext/numeric/time'
require 'json'

module PgEngine
  module Mailgun
    class LogSync
      def self.download

        domain = ENV.fetch('MAILGUN_DOMAIN')

        key = Rails.application.credentials.dig(:mailgun, :api_key)
        mg_client = ::Mailgun::Client.new(key)
        items = []
        end_time = DateTime.now
        start_time = DateTime.now - 3.days
        range = 1.days
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

        dir = File.expand_path 'log/mailgun_logs', Rails.root

        FileUtils.mkdir_p(dir)

        File.write("#{dir}/#{domain}-#{Time.zone.now.strftime('%Y-%m-%d_%H.%M.%S')}.json", items.flatten.to_json)
      end

      def self.sync_redis
        json = []
        dir = File.expand_path 'log/mailgun_logs', Rails.root
        Dir["#{dir}/*.json"].each do |file|
          json.push *JSON.parse(File.read(file))
        end

        json.each do |i|
          # [
          #   Time.at(i["timestamp"]).strftime('%y-%m-%d %H:%M %z'), 
          #   i["message"]["headers"]["message-id"],
          #   # i["message"]["headers"]["message-id"][3..15],
          #   i["event"], 
          #   i["recipient"],
          #   i["message"]["headers"]["from"],
          #   i["message"]["headers"]["subject"],
          # ]
          message_id = i["message"]["headers"]["message-id"]
          email = Email.where(message_id:).first
          if email
            email.logs << i.to_json
          else
            pg_warn "No existe el mail con message_id = #{message_id}", :warn
          end
        end
      end
    end
  end
end
