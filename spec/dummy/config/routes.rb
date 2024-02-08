include PgEngine::RouteHelpers

Rails.application.routes.draw do
  namespace :frontend do
    pg_resource(:cosas)
    pg_resource(:categoria_de_cosas)
  end
  namespace :admin do
    pg_resource(:cosas)
    pg_resource(:categoria_de_cosas)
  end
  devise_for :users
  ActiveAdmin.routes(self)
  root "admin/categoria_de_cosas#index"
end
