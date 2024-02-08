class AdminController < ApplicationController
  include PgEngine::RequireSignIn
  include PgEngine::ResourceHelper
end
