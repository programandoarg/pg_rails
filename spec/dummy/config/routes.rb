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
  root "admin/categoria_de_cosas#index"
end
