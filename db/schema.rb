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

ActiveRecord::Schema.define(:version => 20090814132122) do

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

  create_table "gbif_occurrences", :id => false, :force => true do |t|
    t.text    "Data provider"
    t.text    "Dataset"
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
    t.text    "Provider country"
    t.float   "Latitude"
    t.float   "Longitude"
    t.float   "Coordinate precision"
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

  create_table "geometry_columns", :id => false, :force => true do |t|
    t.string  "f_table_catalog",   :limit => 256, :null => false
    t.string  "f_table_schema",    :limit => 256, :null => false
    t.string  "f_table_name",      :limit => 256, :null => false
    t.string  "f_geometry_column", :limit => 256, :null => false
    t.integer "coord_dimension",                  :null => false
    t.integer "srid",                             :null => false
    t.string  "type",              :limit => 30,  :null => false
  end

  create_table "instcodes", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  create_table "networks", :force => true do |t|
    t.integer "key"
    t.string  "name", :limit => 256, :null => false
  end

  add_index "networks", ["key"], :name => "networks_key_key", :unique => true

# Could not dump table "occurrences" because of following StandardError
#   Unknown type 'geometry' for column 'coordinates'

# Could not dump table "providers" because of following StandardError
#   Unknown type 'geometry' for column 'coordinates'

  create_table "ranks", :force => true do |t|
    t.string "name", :limit => 256
  end

  create_table "resources", :force => true do |t|
    t.integer "key"
    t.string  "name",              :limit => 256,                :null => false
    t.integer "provider_id"
    t.integer "number_of_records",                :default => 0
    t.integer "number_of_species",                :default => 0
    t.date    "last_update"
    t.integer "number_of_taxa",                   :default => 0
    t.integer "count"
  end

  add_index "resources", ["key"], :name => "resources_key_key", :unique => true

  create_table "scientificnames", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
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
