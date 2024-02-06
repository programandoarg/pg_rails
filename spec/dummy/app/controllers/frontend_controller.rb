class FrontendController < ApplicationController
  before_action :authenticate_user!
end
