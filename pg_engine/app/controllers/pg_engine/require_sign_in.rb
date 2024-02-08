# frozen_string_literal: true

module PgEngine
  module RequireSignIn
    def self.included(clazz)
      clazz.before_action :authenticate_user!
    end
  end
end
