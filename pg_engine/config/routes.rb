include PgEngine::RouteHelpers

Rails.application.routes.draw do
  devise_for :users
  namespace :admin, path: 'a' do
    pg_resource(:users)
    pg_resource(:accounts)
    pg_resource(:user_accounts)
  end
  ActiveAdmin.routes(self)
end
