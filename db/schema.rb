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

  create_table "AnnexSpeciesPresence", :force => true do |t|
    t.string "directive",   :limit => 18
    t.string "speciesName", :limit => 61
    t.string "annex I",     :limit => 1
    t.string "annexII",     :limit => 1
    t.string "annexII1",    :limit => 1
    t.string "annexII2",    :limit => 1
    t.string "annexIII1",   :limit => 1
    t.string "annexIII2",   :limit => 1
    t.string "annexIV",     :limit => 1
    t.string "annexV",      :limit => 1
    t.string "priority",    :limit => 1
  end

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

  create_table "gbif_occurrences", :id => false, :force => true do |t|
    t.text    "Data publisher"
    t.text    "Dataset"
    t.text    "Dataset Rigths"
    t.text    "Collector name"
    t.text    "Collector number"
    t.text    "Field number"
    t.text    "GUID"
    t.date    "Date collected"
    t.text    "Institution code"
    t.text    "Collection code"
    t.text    "Catalogue No"
    t.text    "Basis of record"
    t.text    "Image url"
    t.date    "Last indexed"
    t.text    "Identifier"
    t.date    "Identification date"
    t.text    "Scientific name"
    t.text    "Author"
    t.text    "Scientific name (interpreted)"
    t.text    "Kingdom"
    t.text    "Phylum"
    t.text    "Class"
    t.text    "Order"
    t.text    "Family"
    t.text    "Genus"
    t.text    "Country"
    t.text    "Country (interpreted)"
    t.text    "Locality"
    t.text    "County"
    t.text    "Continent or Ocean"
    t.text    "State/Province"
    t.text    "Region"
    t.text    "Publisher country"
    t.float   "Latitude"
    t.float   "Longitude"
    t.text    "Coordinate precision"
    t.integer "Cell id"
    t.integer "Centi cell id"
    t.text    "Min depth"
    t.text    "Max depth"
    t.text    "Max depth2"
    t.text    "Min altitude"
    t.text    "Max altitude"
    t.text    "Altitude precision"
    t.text    "GBIF portal url"
    t.text    "GBIF webservice url"
    t.integer "ft_id"
  end

  add_index "gbif_occurrences", ["GUID"], :name => "guid_idx", :unique => true

  create_table "instcodes", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  create_table "occurrences", :force => true do |t|
    t.integer "key"
    t.integer "basisofrecord_id"
    t.integer "provider_id"
    t.integer "resource_id"
    t.date    "date_collected"
    t.integer "instcode_id"
    t.integer "colcode_id"
    t.string  "catalogue_no",         :limit => 64
    t.date    "last_indexed"
    t.string  "scientific_name",      :limit => 256
    t.integer "scientificname_id"
    t.integer "tkingdom_id"
    t.integer "tphylum_id"
    t.integer "tclass_id"
    t.integer "torder_id"
    t.integer "tfamily_id"
    t.integer "tgenus_id"
    t.string  "locality",             :limit => 1024
    t.integer "providercountry_id"
    t.float   "latitude"
    t.float   "longitude"
    t.float   "coordinate_precision"
    t.integer "cell_id"
    t.integer "centi_cell_id"
    t.string  "coordinates",          :limit => nil
  end

  add_index "occurrences", ["basisofrecord_id"], :name => "basisofrecord_id_idx"
  add_index "occurrences", ["colcode_id"], :name => "colcole_id_idx"
  add_index "occurrences", ["coordinates"], :name => "coordinates_idx"
  add_index "occurrences", ["instcode_id"], :name => "instcode_id_idx"
  add_index "occurrences", ["key"], :name => "occurrences_key_key", :unique => true
  add_index "occurrences", ["provider_id"], :name => "provider_id_idx"
  add_index "occurrences", ["resource_id"], :name => "resource_id_idx"
  add_index "occurrences", ["tclass_id"], :name => "tclass_id_idx"
  add_index "occurrences", ["tfamily_id"], :name => "tfamily_id_idx"
  add_index "occurrences", ["tgenus_id"], :name => "tgenus_id_idx"
  add_index "occurrences", ["tkingdom_id"], :name => "tkingdom_id_idx"
  add_index "occurrences", ["torder_id"], :name => "torder_id_idx"
  add_index "occurrences", ["tphylum_id"], :name => "tphylum_id_idx"
  add_index "occurrences", [nil], :name => "sn_fulltext_idx"

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
