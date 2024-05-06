class UsersController < ApplicationController
  include PgEngine::RequireSignIn

  before_action do
    Current.namespace = :users
  end
end
