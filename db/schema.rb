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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130201040446) do

  create_table "bus_routes", :force => true do |t|
    t.string   "name"
    t.integer  "district_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "color_name"
    t.string   "color_value", :default => "#000000"
  end

  create_table "bus_stops", :force => true do |t|
    t.string   "name"
    t.integer  "district_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "identifier"
    t.boolean  "zpass",      :default => false
  end

  create_table "districts_test_groups", :id => false, :force => true do |t|
    t.integer "district_id"
    t.integer "test_group_id"
  end

  create_table "export_data", :force => true do |t|
    t.string   "kind"
    t.integer  "type_id"
    t.text     "prompt_values"
    t.string   "sort_by"
    t.string   "certificate_title"
    t.string   "distribution_date"
    t.text     "additional_information"
    t.integer  "user_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "export_data_students", :id => false, :force => true do |t|
    t.integer "export_data_id"
    t.integer "student_id"
  end

  create_table "export_list_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "student_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fields", :force => true do |t|
    t.integer  "x"
    t.integer  "y"
    t.integer  "width"
    t.integer  "height"
    t.string   "align"
    t.string   "column"
    t.integer  "template_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "font"
    t.integer  "font_id"
    t.decimal  "text_size",   :default => 12.0
    t.string   "color",       :default => "#000000"
    t.decimal  "spacing",     :default => 0.0
    t.string   "name"
  end

  create_table "fonts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "import_data", :force => true do |t|
    t.string   "model"
    t.text     "defaults"
    t.text     "prompt_values"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "user_id"
  end

  create_table "interventions", :force => true do |t|
    t.integer  "student_id"
    t.string   "name"
    t.string   "start"
    t.string   "stop"
    t.text     "notes"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "completed",  :default => false
  end

  create_table "logins", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pdfs", :force => true do |t|
    t.string   "name"
    t.string   "file_file_name"
    t.integer  "file_file_size"
    t.string   "file_content_type"
    t.datetime "file_updated_at"
    t.integer  "template_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "periods", :force => true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "identifier"
    t.string   "term"
  end

  create_table "periods_students", :id => false, :force => true do |t|
    t.integer "period_id"
    t.integer "student_id"
  end

  create_table "periods_users", :id => false, :force => true do |t|
    t.integer "period_id"
    t.integer "user_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "level"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "district_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "mascot_image_file_name"
    t.string   "mascot_image_content_type"
    t.integer  "mascot_image_file_size"
    t.datetime "mascot_image_updated_at"
    t.string   "identifier"
    t.string   "city"
    t.string   "default_note_header"
    t.text     "default_note_content"
    t.boolean  "hide_teacher",              :default => false
    t.boolean  "hide_socioeconomic_status", :default => false
  end

  create_table "schools_types", :id => false, :force => true do |t|
    t.integer "school_id"
    t.integer "type_id"
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "grade"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "school_id"
    t.string   "identifier"
    t.integer  "bus_stop_id"
    t.integer  "bus_route_id"
    t.string   "bus_rfid"
    t.boolean  "dropped"
    t.boolean  "hispanic",                        :default => false
    t.boolean  "english_learner",                 :default => false
    t.text     "note_1"
    t.text     "note_2"
    t.text     "note_3"
    t.text     "note_4"
    t.boolean  "intervened"
    t.string   "parent_name"
    t.string   "email"
    t.string   "phone"
    t.boolean  "socioeconomically_disadvantaged", :default => false
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "test_scores", :force => true do |t|
    t.integer  "student_id"
    t.string   "test_name"
    t.string   "term"
    t.hstore   "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "test_scores", ["data"], :name => "test_scores_gist_data"

  create_table "types", :force => true do |t|
    t.string   "name"
    t.integer  "pdf_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "school_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role_id"
    t.datetime "user_updated_at"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "last_request_at"
  end

end
