# frozen_string_literal: true

module PgEngine
  class SignedInController < BaseController
    before_action :authenticate_user!
  end
end
