Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :personas do
      collection do
        get :abrir_modal
        post :buscar
      end
    end
  end
  root "admin/personas#index"
  mount PgRails::Engine => "/pg_rails"
end
