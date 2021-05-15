# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170406052832) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
#copy
  create_table "settings", force: :cascade do |t|
    t.text     "about_page_content", limit: 65535
    t.decimal  "lat",                 precision: 10, scale: 6
    t.decimal  "lon",                 precision: 10, scale: 6
  end
 #end copy
  create_table "families", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "phylogeny",  limit: 255
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "images", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "species_id",         limit: 4
    t.string   "genusSpecies",       limit: 255
    t.text     "image_meta",         limit: 65535
    t.string   "creator",            limit: 255
    t.string   "copyright_holder",   limit: 255
  end

  create_table "page_contents", force: :cascade do |t|
    t.text     "about_page_content", limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "species", force: :cascade do |t|
    t.string   "genusSpecies",   limit: 255
    t.string   "commonName",     limit: 255
    t.string   "indigenousName", limit: 255
    t.string   "authority",      limit: 255
    t.text     "distribution",   limit: 65535
    t.text     "information",    limit: 65535
    t.text     "description",    limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "family_id",      limit: 4
    t.string   "slug",           limit: 255
  end

  add_index "species", ["family_id"], name: "index_species_on_family_id", using: :btree
  add_index "species", ["genusSpecies"], name: "index_species_on_genusSpecies", using: :btree

  create_table "species_location_trails", force: :cascade do |t|
    t.integer  "species_location_id", limit: 4
    t.integer  "trail_id",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "order",               limit: 4
  end

  create_table "species_locations", force: :cascade do |t|
    t.integer  "species_id",   limit: 4
    t.decimal  "lat",                        precision: 10, scale: 6
    t.decimal  "lon",                        precision: 10, scale: 6
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.string   "arborplan_id", limit: 255
    t.boolean  "removed",      limit: 1,                              default: false
    t.datetime "removal_date"
    t.text     "information",  limit: 65535
  end

  add_index "species_locations", ["species_id"], name: "index_species_locations_on_species_id", using: :btree

  create_table "species_trails", force: :cascade do |t|
    t.integer "species_id", limit: 4
    t.integer "trail_id",   limit: 4
  end

  add_index "species_trails", ["species_id"], name: "index_species_trails_on_species_id", using: :btree
  add_index "species_trails", ["trail_id"], name: "index_species_trails_on_trail_id", using: :btree

  create_table "trail_points", force: :cascade do |t|
    t.integer  "trail_id",   limit: 4
    t.integer  "order",      limit: 4
    t.decimal  "lat",                  precision: 10, scale: 6
    t.decimal  "lon",                  precision: 10, scale: 6
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "trails", force: :cascade do |t|
    t.text     "name",        limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "slug",        limit: 255
    t.text     "information", limit: 65535
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
