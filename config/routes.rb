PgRails::Engine.routes.draw do
  put 'editar_en_lugar/:id', to: 'pg_rails/editar_en_lugar#actualizar'
end
