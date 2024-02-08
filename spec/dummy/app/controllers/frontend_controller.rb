class FrontendController < ApplicationController
  include PgEngine::RequireSignIn
end
