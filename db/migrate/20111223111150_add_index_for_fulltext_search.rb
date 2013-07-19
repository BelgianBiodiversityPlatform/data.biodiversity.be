class AddIndexForFulltextSearch < ActiveRecord::Migration
  def self.up
    execute "CREATE INDEX sn_fulltext_idx ON occurrences USING gin(to_tsvector('english', scientific_name));"
  end

  def self.down
    execute "DROP INDEX sn_fulltext_idx;"
  end
end
