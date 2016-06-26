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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "curators", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text     "facebook_identifier", null: false
    t.datetime "last_curated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curators_links", primary_key: ["curator_id", "link_id"], force: :cascade do |t|
    t.uuid "curator_id", null: false
    t.uuid "link_id",    null: false
    t.index ["curator_id"], name: "curators_links_curator_id_index", using: :btree
    t.index ["link_id"], name: "curators_links_link_id_index", using: :btree
  end

  create_table "digests", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["recipient_id"], name: "digests_recipient_id_index", using: :btree
  end

  create_table "digests_links", primary_key: ["digest_id", "link_id"], force: :cascade do |t|
    t.uuid "digest_id", null: false
    t.uuid "link_id",   null: false
    t.index ["digest_id"], name: "digests_links_digest_id_index", using: :btree
    t.index ["link_id"], name: "digests_links_link_id_index", using: :btree
  end

  create_table "interests", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text     "stem"
    t.text     "name",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "stems",      default: [],                 array: true
    t.boolean  "published",  default: false, null: false
    t.index ["name"], name: "interests_name_key", unique: true, using: :btree
    t.index ["stem"], name: "interests_stem_index", using: :btree
    t.index ["stem"], name: "interests_stem_key", unique: true, using: :btree
    t.index ["stems"], name: "interests_stems_index", using: :gin
  end

  create_table "interests_links", primary_key: ["interest_id", "link_id"], force: :cascade do |t|
    t.uuid "interest_id", null: false
    t.uuid "link_id",     null: false
    t.index ["interest_id"], name: "interests_links_interest_id_index", using: :btree
    t.index ["link_id"], name: "interests_links_link_id_index", using: :btree
  end

  create_table "interests_recipients", primary_key: ["interest_id", "recipient_id"], force: :cascade do |t|
    t.uuid "interest_id",  null: false
    t.uuid "recipient_id", null: false
    t.index ["interest_id"], name: "interests_recipients_interest_id_index", using: :btree
    t.index ["recipient_id"], name: "interests_recipients_recipient_id_index", using: :btree
  end

  create_table "links", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text     "url",             null: false
    t.text     "title"
    t.text     "description"
    t.datetime "extracted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_curated_at"
    t.bigint   "share_count"
    t.hstore   "image"
    t.index ["url"], name: "links_url_index", using: :btree
    t.index ["url"], name: "links_url_key", unique: true, using: :btree
  end

  create_table "recipients", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text     "email",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "schedule"
    t.text     "next_digest_job_id"
    t.text     "token",              null: false
    t.index ["email"], name: "recipients_email_key", unique: true, using: :btree
    t.index ["token"], name: "recipients_token_key", unique: true, using: :btree
  end

  create_table "schema_info", id: false, force: :cascade do |t|
    t.integer "version", default: 0, null: false
  end

  add_foreign_key "curators_links", "curators", name: "curators_links_curator_id_fkey", on_delete: :cascade
  add_foreign_key "curators_links", "links", name: "curators_links_link_id_fkey", on_delete: :cascade
  add_foreign_key "digests", "recipients", name: "digests_recipient_id_fkey", on_delete: :cascade
  add_foreign_key "digests_links", "digests", name: "digests_links_digest_id_fkey", on_delete: :cascade
  add_foreign_key "digests_links", "links", name: "digests_links_link_id_fkey", on_delete: :cascade
  add_foreign_key "interests_links", "interests", name: "interests_links_interest_id_fkey", on_delete: :cascade
  add_foreign_key "interests_links", "links", name: "interests_links_link_id_fkey", on_delete: :cascade
  add_foreign_key "interests_recipients", "interests", name: "interests_recipients_interest_id_fkey", on_delete: :cascade
  add_foreign_key "interests_recipients", "recipients", name: "interests_recipients_recipient_id_fkey", on_delete: :cascade
end
