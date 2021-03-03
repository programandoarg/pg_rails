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

ActiveRecord::Schema.define(version: 2020_03_16_155535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
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
    t.datetime "deleted_at"
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
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actualizado_por_id"], name: "index_cosas_on_actualizado_por_id"
    t.index ["categoria_de_cosa_id"], name: "index_cosas_on_categoria_de_cosa_id"
    t.index ["creado_por_id"], name: "index_cosas_on_creado_por_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "profiles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categoria_de_cosas", "users", column: "actualizado_por_id"
  add_foreign_key "categoria_de_cosas", "users", column: "creado_por_id"
  add_foreign_key "cosas", "categoria_de_cosas"
  add_foreign_key "cosas", "users", column: "actualizado_por_id"
  add_foreign_key "cosas", "users", column: "creado_por_id"
end
