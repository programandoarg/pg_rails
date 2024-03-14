module PgEngine
  module PgRailsHelper
    def dev?
      Rails.env.development? || current_user&.developer?
    end
  end
end
