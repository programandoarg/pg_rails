Rails.application.routes.draw do
  namespace :admin do
    resources :categoria_de_cosas do
      collection do
        get :abrir_modal
        post :buscar
      end
    end
  end
  devise_for :users
  ActiveAdmin.routes(self)
  root "admin/categoria_de_cosas#index"
end
