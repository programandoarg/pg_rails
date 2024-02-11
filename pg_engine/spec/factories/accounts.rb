# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :account do
    plan { Account.plan.values.sample }
    nombre { Faker::Lorem.sentence }
    hashid { Faker::Lorem.sentence }
  end
end
