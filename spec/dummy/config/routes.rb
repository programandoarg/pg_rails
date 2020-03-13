Rails.application.routes.draw do
  mount PgRails::Engine => '/pg_rails'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
