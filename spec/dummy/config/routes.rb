Rails.application.routes.draw do
  namespace :admin do
    end
  devise_for :users
  ActiveAdmin.routes(self)
  root "admin/categoria_de_cosas#index"
end
