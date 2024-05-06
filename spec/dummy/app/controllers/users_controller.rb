class UsersController < ApplicationController
  include PgEngine::RequireSignIn
end
