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

class User < ApplicationRecord
  devise

  def admin?
    true
  end

  def to_s
    email
  end
end
