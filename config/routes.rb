PgRails::Engine.routes.draw do
  put 'editar_en_lugar/:id', to: 'editar_en_lugar#actualizar', as: :editar_en_lugar
end
