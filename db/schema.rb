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

ActiveRecord::Schema.define(version: 0) do

  create_table "digital_objects", primary_key: "digital_object_id", force: true do |t|
    t.string "home_repository", limit: 3, null: false
  end

  create_table "dpn_objects", primary_key: "dpn_object_id", force: true do |t|
  end

  create_table "dpn_replicas", primary_key: "replica_id", force: true do |t|
    t.string    "dpn_object_id", limit: 40, null: false
    t.timestamp "submit_date",   limit: 6,  null: false
    t.timestamp "accept_date",   limit: 6,  null: false
    t.timestamp "verify_date",   limit: 6
  end

  create_table "replicas", id: false, force: true do |t|
    t.string    "replica_id",          limit: 40,                          null: false
    t.string    "home_repository",     limit: 3,                           null: false
    t.timestamp "create_date",         limit: 6,                           null: false
    t.string    "payload_fixity_type", limit: 7,                           null: false
    t.string    "payload_fixity",      limit: 64,                          null: false
    t.integer   "payload_size",                   precision: 38, scale: 0, null: false
  end

  create_table "sdr_object_versions", id: false, force: true do |t|
    t.string    "sdr_object_id",  limit: 17,                          null: false
    t.integer   "sdr_version_id",            precision: 38, scale: 0, null: false
    t.timestamp "ingest_date",    limit: 6
    t.string    "replica_id",     limit: 23
  end

  create_table "sdr_objects", primary_key: "sdr_object_id", force: true do |t|
    t.string  "object_type",      limit: 20,                           null: false
    t.string  "governing_object", limit: 17
    t.string  "object_label",     limit: 100
    t.integer "latest_version",               precision: 38, scale: 0
  end

  create_table "sdr_version_stats", id: false, force: true do |t|
    t.string  "sdr_object_id",   limit: 17,                          null: false
    t.integer "sdr_version_id",             precision: 38, scale: 0, null: false
    t.string  "inventory_type",  limit: 5,                           null: false
    t.integer "content_files",              precision: 38, scale: 0, null: false
    t.integer "content_bytes",              precision: 38, scale: 0, null: false
    t.integer "content_blocks",             precision: 38, scale: 0, null: false
    t.integer "metadata_files",             precision: 38, scale: 0, null: false
    t.integer "metadata_blocks",            precision: 38, scale: 0, null: false
    t.integer "metadata_bytes",             precision: 38, scale: 0
  end

  create_table "tape_archives", primary_key: "tape_archive_id", force: true do |t|
    t.string    "tape_server", limit: 32, null: false
    t.string    "tape_node",   limit: 32, null: false
    t.timestamp "submit_date", limit: 6,  null: false
    t.timestamp "accept_date", limit: 6
    t.timestamp "verify_date", limit: 6
  end

  create_table "tape_replicas", id: false, force: true do |t|
    t.string "replica_id",      limit: 40, null: false
    t.string "tape_archive_id", limit: 32, null: false
  end

  add_foreign_key "sdr_version_stats", "sdr_object_versions", columns: ["sdr_object_id", "sdr_version_id"], name: "sdr_version_stats_sdr_obj_fk1"

end
