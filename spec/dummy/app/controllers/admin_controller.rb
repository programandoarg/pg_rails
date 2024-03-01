class AdminController < ApplicationController
  include PgEngine::RequireSignIn
  include PgEngine::Resource
end
