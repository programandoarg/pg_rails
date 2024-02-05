Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  namespace :admin do
    resources :blas do
      collection do
        get :abrir_modal
        post :buscar
      end
    end
    resources :categoria_de_cosas do
      collection do
        get :abrir_modal
        post :buscar
      end
    end
    resources :cosas do
      collection do
        get :abrir_modal
        post :buscar
      end
    end
    resources :personas do
      collection do
        get :abrir_modal
        post :buscar
      end
    end
  end
  root "admin/personas#index"
end
