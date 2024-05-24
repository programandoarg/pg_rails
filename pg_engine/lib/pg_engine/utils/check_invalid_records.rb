# :nocov:
module PgEngine
  module Utils
    class CheckInvalidRecords
      def run
        invalids = []
        classes.each do |klass|
          klass.find_each do |record|
            invalids << record unless record.valid?
          end
        end
        invalids.map do |r|
          [
            (r.account.to_s if r.respond_to?(:account)),
            r.class.to_s,
            r.id,
            r.errors.full_messages
          ]
        end
      end

      def classes
        ActiveRecord::Base.descendants - ignored_classes
      end

      def ignored_classes
        [
          ActiveStorage::Record,
          PgEngine::BaseRecord,
          ActiveAdmin::Comment,
          Audited::Audit,
          ActiveStorage::Blob,
          ApplicationRecord
        ]
      end
    end
  end
end
# :nocov:
