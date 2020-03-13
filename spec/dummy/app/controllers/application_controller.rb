class ApplicationController < PgRails::ApplicationController
  before_action do
    unless current_user.present?
      user = User.first_or_create(FactoryBot.attributes_for(:user))
      sign_in User.first
    end
  end
end
