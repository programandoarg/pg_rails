class FrontendController < ApplicationController
  include PgEngine::RequireSignIn
  include PgEngine::Resource
end
