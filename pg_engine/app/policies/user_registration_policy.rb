# frozen_string_literal: true

class UserRegistrationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def new?
    create?
  end

  def create?
    user.blank?
  end

  def edit?
    update?
  end

  def update?
    user == record
  end
end
