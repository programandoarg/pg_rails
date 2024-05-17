# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_17_174855) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "accounts", force: :cascade do |t|
    t.integer "plan", null: false
    t.string "nombre", null: false
    t.bigint "creado_por_id"
    t.bigint "actualizado_por_id"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actualizado_por_id"], name: "index_accounts_on_actualizado_por_id"
    t.index ["creado_por_id"], name: "index_accounts_on_creado_por_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "categoria_de_cosas", force: :cascade do |t|
    t.string "nombre", null: false
    t.integer "tipo", null: false
    t.date "fecha"
    t.datetime "tiempo"
    t.bigint "creado_por_id"
    t.bigint "actualizado_por_id"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actualizado_por_id"], name: "index_categoria_de_cosas_on_actualizado_por_id"
    t.index ["creado_por_id"], name: "index_categoria_de_cosas_on_creado_por_id"
  end

  create_table "cosas", force: :cascade do |t|
    t.string "nombre", null: false
    t.integer "tipo", null: false
    t.bigint "categoria_de_cosa_id", null: false
    t.bigint "creado_por_id"
    t.bigint "actualizado_por_id"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actualizado_por_id"], name: "index_cosas_on_actualizado_por_id"
    t.index ["categoria_de_cosa_id"], name: "index_cosas_on_categoria_de_cosa_id"
    t.index ["creado_por_id"], name: "index_cosas_on_creado_por_id"
  end

  create_table "emails", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "delivered_at"
    t.datetime "opened_at"
    t.string "from_address", null: false
    t.string "from_name"
    t.string "reply_to"
    t.string "to", null: false
    t.string "subject"
    t.string "body_input"
    t.string "tags", array: true
    t.string "associated_type"
    t.bigint "associated_id"
    t.string "message_id"
    t.string "mailer"
    t.string "status_detail"
    t.integer "status", default: 0, null: false
    t.bigint "creado_por_id"
    t.bigint "actualizado_por_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actualizado_por_id"], name: "index_emails_on_actualizado_por_id"
    t.index ["associated_type", "associated_id"], name: "index_emails_on_associated"
    t.index ["creado_por_id"], name: "index_emails_on_creado_por_id"
  end

  create_table "mensaje_contactos", force: :cascade do |t|
    t.string "nombre"
    t.string "email"
    t.string "telefono"
    t.string "mensaje"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.integer "profiles", default: [], null: false, array: true
    t.bigint "creado_por_id"
    t.bigint "actualizado_por_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_user_accounts_on_account_id"
    t.index ["actualizado_por_id"], name: "index_user_accounts_on_actualizado_por_id"
    t.index ["creado_por_id"], name: "index_user_accounts_on_creado_por_id"
    t.index ["user_id"], name: "index_user_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "developer", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "nombre", null: false
    t.string "apellido", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "accounts", "users", column: "actualizado_por_id"
  add_foreign_key "accounts", "users", column: "creado_por_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categoria_de_cosas", "users", column: "actualizado_por_id"
  add_foreign_key "categoria_de_cosas", "users", column: "creado_por_id"
  add_foreign_key "cosas", "categoria_de_cosas"
  add_foreign_key "cosas", "users", column: "actualizado_por_id"
  add_foreign_key "cosas", "users", column: "creado_por_id"
  add_foreign_key "emails", "users", column: "actualizado_por_id"
  add_foreign_key "emails", "users", column: "creado_por_id"
  add_foreign_key "user_accounts", "accounts"
  add_foreign_key "user_accounts", "users"
  add_foreign_key "user_accounts", "users", column: "actualizado_por_id"
  add_foreign_key "user_accounts", "users", column: "creado_por_id"
end
