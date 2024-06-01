class AdminController < ApplicationController
  include PgEngine::RequireSignIn
  before_action do
    Current.namespace = :admin
  end
end
