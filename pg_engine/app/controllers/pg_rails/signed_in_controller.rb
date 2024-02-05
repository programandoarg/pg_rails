# frozen_string_literal: true

module PgRails
  class SignedInController < BaseController
    before_action :authenticate_user!
  end
end
