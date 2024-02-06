Rails.application.routes.draw do
  namespace :admin do
    PgEngine.resource_route(self, :categoria_de_cosas)
  end
  devise_for :users
  ActiveAdmin.routes(self)
  root "admin/categoria_de_cosas#index"
end
