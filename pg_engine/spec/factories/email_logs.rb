# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :email_log do
    email
    log_id { Faker::Lorem.sentence }
    event { %w[accepted delivered failed opened].sample }
    log_level { %w[info warn error].sample }
    severity { %w[permanent temporary].sample }
    timestamp { '' }
    message_id { Faker::Lorem.sentence }

    trait :email_existente do
      email { nil }
      email_id { Email.pluck(:id).sample }
    end
  end
end
