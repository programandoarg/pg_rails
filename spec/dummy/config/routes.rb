Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  root "admin/categoria_de_cosas#index"
end
