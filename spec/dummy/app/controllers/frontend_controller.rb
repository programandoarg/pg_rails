class FrontendController < ApplicationController
  include PgEngine::RequireSignIn
  include PgEngine::ResourceHelper
end
