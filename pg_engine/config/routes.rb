include PgEngine::RouteHelpers

Rails.application.routes.draw do
  devise_for :users
  namespace :admin, path: 'a' do
    pg_resource(:users)
  end
  ActiveAdmin.routes(self)
end
