# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :user_account do
    association :user
    association :account
    profiles { UserAccount.profiles.values.sample }

    trait :user_existente do
      user { nil }
      user_id { User.pluck(:id).sample }
    end

    trait :account_existente do
      account { nil }
      account_id { Account.pluck(:id).sample }
    end
  end
end
