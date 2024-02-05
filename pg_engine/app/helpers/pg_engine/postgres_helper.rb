# frozen_string_literal: true

module PgEngine
  module PostgresHelper
    # Le pone la timezone
    def add_timezone(field)
      "#{field}::TIMESTAMPTZ AT TIME ZONE INTERVAL '-03:00'::INTERVAL"
    end

    # Le pone la timezone y lo convierte a Date
    def get_date_tz(field)
      "(#{add_timezone(field)})::date"
    end
  end
end
