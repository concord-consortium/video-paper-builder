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

ActiveRecord::Schema.define(version: 20200330013855) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "password_salt",          limit: 255, default: ""
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token",   limit: 255
    t.string   "remember_token",         limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.datetime "invitation_created_at"
  end

  add_index "admins", ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true, using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["invitation_token"], name: "index_admins_on_invitation_token", using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "schoology_realms", force: :cascade do |t|
    t.string   "realm_type",   limit: 255
    t.integer  "schoology_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "schoology_realms", ["realm_type", "schoology_id"], name: "index_schoology_realms_on_realm_type_and_schoology_id", unique: true, using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "content",          limit: 65535
    t.integer  "video_paper_id",   limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "video_start_time", limit: 255
    t.string   "video_stop_time",  limit: 255
  end

  create_table "shared_papers", force: :cascade do |t|
    t.integer  "video_paper_id", limit: 4
    t.integer  "user_id",        limit: 4
    t.text     "notes",          limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "password_salt",          limit: 255, default: "", null: false
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token",   limit: 255
    t.string   "remember_token",         limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.datetime "reset_password_sent_at"
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.datetime "invitation_created_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_papers", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "owner_id",   limit: 4
    t.string   "status",     limit: 255, default: "unpublished"
  end

  create_table "videos", force: :cascade do |t|
    t.string   "entry_id",                          limit: 255
    t.text     "description",                       limit: 65535
    t.integer  "video_paper_id",                    limit: 4
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "thumbnail_file_name",               limit: 255
    t.string   "thumbnail_content_type",            limit: 255
    t.integer  "thumbnail_file_size",               limit: 4
    t.datetime "thumbnail_updated_at"
    t.string   "duration",                          limit: 255
    t.boolean  "processed"
    t.string   "thumbnail_time",                    limit: 255
    t.boolean  "private"
    t.string   "upload_uri",                        limit: 255
    t.string   "transcoded_uri",                    limit: 255
    t.string   "aws_transcoder_job",                limit: 255
    t.string   "aws_transcoder_state",              limit: 255
    t.datetime "aws_transcoder_submitted_at"
    t.text     "aws_transcoder_last_notification",  limit: 65535
    t.integer  "aws_transcoder_retries",            limit: 4,     default: 0
    t.datetime "aws_transcoder_first_submitted_at"
  end

  create_table "wysihat_files", force: :cascade do |t|
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id",           limit: 4
  end

end
