Rails.application.routes.draw do
  mount PgRails::Engine => "/pg_rails"
end
