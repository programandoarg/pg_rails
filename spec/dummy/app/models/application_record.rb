# frozen_string_literal: true

class ApplicationRecord < PgRails::ApplicationRecord
  self.abstract_class = true
end
