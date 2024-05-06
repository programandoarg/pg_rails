# frozen_string_literal: true

# generado con pg_rails

FactoryBot.define do
  factory :email do
    # accepted_at { "2024-05-06 16:41:06" }
    # delivered_at { "2024-05-06 16:41:06" }
    # opened_at { "2024-05-06 16:41:06" }
    from_address { Faker::Internet.email }
    from_name { Faker::Name.name }
    reply_to { Faker::Internet.email }
    to { Faker::Internet.email }
    subject { Faker::Lorem.sentence }
    body_input { Faker::Lorem.sentence }
    # tags { Faker::Lorem.sentence }
    # associated
    # content_eml { Faker::Lorem.sentence }
    # message_id { Faker::Lorem.sentence }
    # mailer { Faker::Lorem.sentence }
    # status_detail { Faker::Lorem.sentence }
    # status { rand(1..9999) }

    # trait :associated_existente do
    #   associated { nil }
    #   associated_id { Associated.pluck(:id).sample }
    # end
  end
end
