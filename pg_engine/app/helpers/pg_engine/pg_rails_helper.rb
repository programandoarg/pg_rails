module PgEngine
  module PgRailsHelper
    def dev?
      Rails.env.development? || current_user&.developer?
    end

    def current_account
      current_user&.current_account
    end
  end
end
