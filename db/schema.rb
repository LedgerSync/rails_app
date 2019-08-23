# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_23_115157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_tokens", id: :string, force: :cascade do |t|
    t.string "user_id"
    t.datetime "used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_auth_tokens_on_user_id"
  end

  create_table "events", id: :string, force: :cascade do |t|
    t.string "type"
    t.text "data"
    t.string "event_object_id"
    t.string "event_object_type"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_object_id", "event_object_type"], name: "index_events_on_event_object_id_and_event_object_type"
    t.index ["organization_id"], name: "index_events_on_organization_id"
    t.index ["type"], name: "index_events_on_type"
  end

  create_table "idempotency_keys", force: :cascade do |t|
    t.string "key"
    t.jsonb "response_body"
    t.integer "response_status"
    t.string "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "request_body"
    t.index ["key"], name: "index_idempotency_keys_on_key"
    t.index ["request_id"], name: "index_idempotency_keys_on_request_id"
  end

  create_table "ledger_resources", id: :string, force: :cascade do |t|
    t.string "ledger_id"
    t.string "resource_id"
    t.string "resource_ledger_id"
    t.string "approved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_ledger_resources_on_approved_by_id"
    t.index ["ledger_id"], name: "index_ledger_resources_on_ledger_id"
    t.index ["resource_id", "ledger_id"], name: "index_ledger_resources_on_resource_id_and_ledger_id", unique: true
    t.index ["resource_id"], name: "index_ledger_resources_on_resource_id"
  end

  create_table "ledgers", id: :string, force: :cascade do |t|
    t.string "kind"
    t.string "organization_id"
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.jsonb "data"
    t.string "connected_by"
    t.string "disconnected_by"
    t.datetime "disconnected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["connected_by"], name: "index_ledgers_on_connected_by"
    t.index ["disconnected_at"], name: "index_ledgers_on_disconnected_at"
    t.index ["disconnected_by"], name: "index_ledgers_on_disconnected_by"
    t.index ["organization_id"], name: "index_ledgers_on_organization_id"
  end

  create_table "organization_users", force: :cascade do |t|
    t.string "organization_id"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_organization_users_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", id: :string, force: :cascade do |t|
    t.string "external_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_organizations_on_external_id", unique: true
  end

  create_table "resources", id: :string, force: :cascade do |t|
    t.string "external_id"
    t.string "type"
    t.string "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id", "type"], name: "index_resources_on_external_id_and_type", unique: true
    t.index ["organization_id"], name: "index_resources_on_organization_id"
  end

  create_table "sync_ledger_logs", id: :string, force: :cascade do |t|
    t.string "action", null: false
    t.string "sync_ledger_id"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sync_ledger_id"], name: "index_sync_ledger_logs_on_sync_ledger_id"
  end

  create_table "sync_ledgers", id: :string, force: :cascade do |t|
    t.string "sync_id"
    t.string "ledger_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ledger_id"], name: "index_sync_ledgers_on_ledger_id"
    t.index ["status"], name: "index_sync_ledgers_on_status"
    t.index ["sync_id", "ledger_id"], name: "index_sync_ledgers_on_sync_id_and_ledger_id", unique: true
    t.index ["sync_id"], name: "index_sync_ledgers_on_sync_id"
  end

  create_table "sync_resources", id: :string, force: :cascade do |t|
    t.string "sync_id"
    t.string "resource_id"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_sync_resources_on_resource_id"
    t.index ["sync_id", "resource_id"], name: "index_sync_resources_on_sync_id_and_resource_id", unique: true
    t.index ["sync_id"], name: "index_sync_resources_on_sync_id"
  end

  create_table "syncs", id: :string, force: :cascade do |t|
    t.string "organization_id"
    t.string "resource_id"
    t.string "resource_type"
    t.string "resource_external_id"
    t.string "operation_method"
    t.jsonb "references"
    t.integer "status", default: 0, null: false
    t.text "status_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.serial "position", null: false
    t.index ["organization_id"], name: "index_syncs_on_organization_id"
    t.index ["resource_id"], name: "index_syncs_on_resource_id"
    t.index ["status"], name: "index_syncs_on_status"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "external_id"
    t.string "email"
    t.boolean "is_admin"
    t.string "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["external_id"], name: "index_users_on_external_id", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "auth_tokens", "users"
  add_foreign_key "ledger_resources", "ledgers"
  add_foreign_key "ledger_resources", "resources"
  add_foreign_key "ledger_resources", "users", column: "approved_by_id"
  add_foreign_key "ledgers", "organizations"
  add_foreign_key "ledgers", "users", column: "connected_by"
  add_foreign_key "ledgers", "users", column: "disconnected_by"
  add_foreign_key "organization_users", "organizations"
  add_foreign_key "organization_users", "users"
  add_foreign_key "resources", "organizations"
  add_foreign_key "sync_ledger_logs", "sync_ledgers"
  add_foreign_key "sync_ledgers", "ledgers"
  add_foreign_key "sync_ledgers", "syncs"
  add_foreign_key "sync_resources", "resources"
  add_foreign_key "sync_resources", "syncs"
  add_foreign_key "syncs", "organizations"
  add_foreign_key "syncs", "resources"
  add_foreign_key "users", "organizations"
end
