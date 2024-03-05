include PgEngine::RouteHelpers

Rails.application.routes.draw do
  devise_for :users
  namespace :admin, path: 'a' do
    pg_resource(:users)
    pg_resource(:accounts)
    pg_resource(:user_accounts)
    get 'login_as', to: 'users#login_as'
  end
  ActiveAdmin.routes(self)
end
