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
        all = ActiveRecord::Base.descendants.select { |m| m.table_name.present? }
        all - ignored_classes
      end

      def ignored_classes
        [
          ActionText::Record,
          ActionMailbox::Record,
          ActiveAdmin::Comment,
          ActiveStorage::Record,
          PgEngine::BaseRecord,
          Audited::Audit,
          ActionText::RichText,
          ActionText::EncryptedRichText,
          ActionMailbox::InboundEmail,
          ActiveStorage::VariantRecord,
          ActiveStorage::Attachment,
          ActiveStorage::Blob,
          ApplicationRecord
        ]
      end
    end
  end
end
# :nocov:
