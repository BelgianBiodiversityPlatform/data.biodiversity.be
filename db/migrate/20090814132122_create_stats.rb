class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer :total_occurrences
      t.integer :georef_occurrences
      t.date  :last_update
    end

    total = Occurrence.count
    georef = Occurrence.count(:conditions => 'coordinates IS NOT NULL')

    execute "INSERT INTO stats (total_occurrences, georef_occurrences, last_update)
    VALUES (#{total}, #{georef}, NOW())"
  end

  def self.down
    drop_table  :stats
  end
end
