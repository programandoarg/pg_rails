# frozen_string_literal: true

# == Schema Information
#
# Table name: personas
#
#  id         :bigint           not null, primary key
#  apellido   :string
#  nombre     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :persona do
    nombre { Faker::Lorem.sentence }
    apellido { Faker::Lorem.sentence }
  end
end
