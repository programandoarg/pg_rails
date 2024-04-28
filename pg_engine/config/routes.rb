include PgEngine::RouteHelpers

Rails.application.routes.draw do
  namespace :public, path: '' do
    pg_resource(:mensaje_contactos, only: [:new, :create], path: 'contacto')
  end
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations'
  }
  namespace :admin, path: 'a' do
    pg_resource(:users)
    pg_resource(:accounts)
    pg_resource(:user_accounts)
    get 'login_as', to: 'users#login_as'
  end
  ActiveAdmin.routes(self)
end
