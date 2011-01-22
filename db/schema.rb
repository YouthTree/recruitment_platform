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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110122095010) do

  create_table "contents", :force => true do |t|
    t.text     "content"
    t.string   "key"
    t.string   "title"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "rendered_content"
  end

  create_table "email_addresses", :force => true do |t|
    t.string   "email"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_addresses", ["addressable_id", "addressable_type"], :name => "index_email_addresses_on_addressable_id_and_addressable_type"

  create_table "position_applications", :force => true do |t|
    t.integer  "position_id"
    t.string   "full_name"
    t.string   "phone"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_answers"
    t.string   "state"
    t.string   "searchable_identifier"
  end

  add_index "position_applications", ["state"], :name => "index_position_applications_on_state"

  create_table "position_questions", :force => true do |t|
    t.integer  "position_id"
    t.integer  "question_id"
    t.integer  "order_position"
    t.boolean  "required"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", :force => true do |t|
    t.string   "title"
    t.text     "short_description"
    t.integer  "team_id"
    t.boolean  "paid",                           :default => false
    t.string   "duration"
    t.integer  "time_commitment"
    t.text     "rendered_paid_description"
    t.text     "rendered_general_description"
    t.text     "rendered_position_description"
    t.text     "rendered_applicant_description"
    t.text     "general_description"
    t.text     "position_description"
    t.text     "applicant_description"
    t.text     "paid_description"
    t.datetime "published_at"
    t.datetime "expires_at"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_commitment_flexibility"
    t.integer  "order_position"
  end

  add_index "positions", ["cached_slug"], :name => "index_positions_on_cached_slug"

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.string   "short_name"
    t.text     "hint"
    t.text     "metadata"
    t.string   "question_type"
    t.string   "default_value"
    t.boolean  "required_by_default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "scope"
    t.string   "slug"
    t.integer  "record_id"
    t.datetime "created_at"
  end

  add_index "slugs", ["scope", "record_id", "created_at"], :name => "index_slugs_on_scope_and_record_id_and_created_at"
  add_index "slugs", ["scope", "record_id"], :name => "index_slugs_on_scope_and_record_id"
  add_index "slugs", ["scope", "slug", "created_at"], :name => "index_slugs_on_scope_and_slug_and_created_at"
  add_index "slugs", ["scope", "slug"], :name => "index_slugs_on_scope_and_slug"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "teams", :force => true do |t|
    t.string   "name",                 :null => false
    t.string   "website_url"
    t.text     "description"
    t.text     "rendered_description"
    t.string   "cached_slug"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["cached_slug"], :name => "index_teams_on_cached_slug"

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
