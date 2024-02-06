Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  namespace :admin do
    resources :categoria_de_cosas do
      collection do
        get :abrir_modal
        post :buscar
      end
    end
  end
  root "admin/categoria_de_cosas#index"
end
