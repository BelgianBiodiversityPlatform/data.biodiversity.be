# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111223111150) do

  create_table "basisofrecords", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  create_table "colcodes", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  create_table "countries", :force => true do |t|
    t.string  "name",  :limit => 256
    t.string  "code",  :limit => 4
    t.integer "count"
  end

  create_table "flattaxons", :force => true do |t|
    t.integer "k_id"
    t.integer "p_id"
    t.integer "c_id"
    t.integer "o_id"
    t.integer "f_id"
    t.integer "g_id"
    t.string  "k_name", :limit => 256
    t.string  "p_name", :limit => 256
    t.string  "c_name", :limit => 256
    t.string  "o_name", :limit => 256
    t.string  "f_name", :limit => 256
    t.string  "g_name", :limit => 256
  end

  create_table "gbif_export", :id => false, :force => true do |t|
    t.integer  "data_provider_id",                                        :null => false
    t.integer  "data_resource_id",                                        :null => false
    t.string   "data_provider"
    t.string   "dataset"
    t.string   "collector_name"
    t.string   "date_collected",           :limit => 50
    t.string   "institution_code"
    t.string   "collection_code"
    t.string   "catalogue_number"
    t.string   "basis_of_record",          :limit => 100
    t.datetime "last_indexed"
    t.string   "identifier"
    t.datetime "identification_date"
    t.string   "scientific_name_original"
    t.string   "author"
    t.string   "scientific_name",                                         :null => false
    t.string   "kingdom"
    t.string   "phylum"
    t.string   "class"
    t.string   "order_rank"
    t.string   "genus"
    t.string   "country",                  :limit => 2
    t.text     "locality"
    t.string   "county",                   :limit => 100
    t.string   "continent_or_ocean",       :limit => 100
    t.string   "state_province",           :limit => 100
    t.string   "region",                   :limit => 3
    t.string   "provider_country",         :limit => 2
    t.string   "latitude",                 :limit => 50
    t.string   "longitude",                :limit => 50
    t.string   "coordinate_precision",     :limit => 50
    t.integer  "geospatial_issue"
    t.integer  "cell_id"
    t.integer  "centi_cell_id"
    t.string   "min_depth",                :limit => 50
    t.string   "max_depth",                :limit => 50
    t.string   "min_altitude",             :limit => 50
    t.string   "max_altitude",             :limit => 50
    t.string   "altitude_precision",       :limit => 50
    t.text     "gbif_portal_url",                         :default => "", :null => false
    t.text     "gbif_webservice_url",                     :default => "", :null => false
    t.integer  "occurrence_id",                                           :null => false
    t.integer  "nub_concept_id"
  end

  add_index "gbif_export", ["coordinate_precision"], :name => "aaaa"
  add_index "gbif_export", ["latitude"], :name => "gbif_export_latitude_idx"
  add_index "gbif_export", ["longitude"], :name => "gbif_export_longitude_idx"

  create_table "instcodes", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  create_table "networks", :id => false, :force => true do |t|
    t.integer "id",                                         :null => false
    t.string  "name",                         :limit => 64, :null => false
    t.string  "shortidentifier",              :limit => 64, :null => false
    t.string  "websiteurl",                   :limit => 64
    t.integer "occurrencecount"
    t.integer "georeferencedoccurrencecount"
  end

# Could not dump table "occurrences" because of following StandardError
#   Unknown type 'geometry' for column 'coordinates_google'

  create_table "providers", :id => false, :force => true do |t|
    t.integer  "id",                                          :null => false
    t.string   "name",                         :limit => 256, :null => false
    t.string   "websiteurl",                   :limit => 256
    t.integer  "taxonconceptcount"
    t.integer  "occurrencecount"
    t.integer  "georeferencedoccurrencecount"
    t.string   "isocountrycode",               :limit => 2
    t.integer  "country_id"
    t.datetime "created"
    t.datetime "modified"
    t.integer  "count"
  end

  create_table "ranks", :id => false, :force => true do |t|
    t.integer "id",                  :null => false
    t.string  "name", :limit => 256
  end

  create_table "resources", :id => false, :force => true do |t|
    t.integer  "id",                                  :null => false
    t.integer  "provider_id"
    t.string   "name",                 :limit => 256, :null => false
    t.string   "defaultbasisofrecord", :limit => 64
    t.datetime "created"
    t.datetime "modified"
    t.integer  "count"
    t.integer  "geo_count"
  end

  create_table "scientificnames", :force => true do |t|
    t.string  "name",            :limit => 256, :null => false
    t.string  "col_url",         :limit => 128
    t.string  "col_rank",        :limit => 64
    t.string  "col_name_status", :limit => 64
    t.boolean "col_done"
  end

  create_table "stats", :force => true do |t|
    t.integer "total_occurrences"
    t.integer "georef_occurrences"
    t.date    "last_update"
  end

  create_table "taxons", :force => true do |t|
    t.integer "rank_id"
    t.integer "parent_id"
    t.string  "name",      :limit => 256
  end

end
