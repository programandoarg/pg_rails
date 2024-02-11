Rails.application.routes.draw do
  namespace :admin, path: 'a' do
    pg_resource(:users)
  end
end
