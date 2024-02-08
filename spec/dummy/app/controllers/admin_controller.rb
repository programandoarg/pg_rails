class AdminController < ApplicationController
  include PgEngine::RequireSignIn
end
