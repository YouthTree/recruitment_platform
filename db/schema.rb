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

ActiveRecord::Schema.define(:version => 20101218165338) do

  create_table "positions", :force => true do |t|
    t.string   "title"
    t.text     "short_description"
    t.integer  "team_id"
    t.boolean  "paid",                           :default => false
    t.string   "duration"
    t.decimal  "time_commitment"
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

end
