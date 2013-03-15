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

ActiveRecord::Schema.define(:version => 20130315173212) do

  create_table "decisions", :force => true do |t|
    t.string   "doc_file"
    t.date     "promulgated_on"
    t.text     "html"
    t.string   "pdf_file"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "text"
    t.string   "original_filename"
    t.string   "appeal_number"
    t.string   "url"
    t.integer  "tribunal_id"
    t.boolean  "reportable"
  end

  add_index "decisions", ["promulgated_on"], :name => "index_decisions_on_promulgated_on", :order => {"promulgated_on"=>:desc}

  create_table "import_errors", :force => true do |t|
    t.string   "error"
    t.text     "backtrace"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "decision_id"
  end

end
