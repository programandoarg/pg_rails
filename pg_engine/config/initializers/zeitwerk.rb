Rails.autoloaders.main.ignore(
  "#{Rails.root}/app/admin",
  "#{PgEngine::Engine.root}/app/admin",
  "#{PgEngine::Engine.root}/app/assets",
  "#{PgEngine::Engine.root}/app/javascript",
  "#{PgEngine::Engine.root}/app/overrides",
  "#{PgEngine::Engine.root}/app/views"
)

Rails.autoloaders.main.collapse("#{PgEngine::Engine.root}/app/components/inline_edit")
