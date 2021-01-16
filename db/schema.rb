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

ActiveRecord::Schema.define(version: 20210115001357) do

  create_table "parks", force: :cascade do |t|
    t.string "name"
    t.integer "difficulty_rating"
    t.string "geolocation"
    t.boolean "vert_park"
    t.boolean "street_park"
    t.boolean "skate_spot"
    t.boolean "skateboard_permitted"
    t.boolean "scooter_permitted"
    t.boolean "bike_permitted"
    t.time "open_time"
    t.time "close_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
