# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  created_at :datetime         not null
#  email      :string           not null
#  id         :bigint           not null, primary key
#  profiles   :string
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.email }
  end

  trait :admin # Dummy trait
end
