class Stat < ActiveRecord::Base
  # Only 1 record (generated when creatin the table in a migration)
  # Re-run migration to update counters
  @@statsrecord = find(:first)

  def self.count_all
    @@statsrecord.total_occurrences
  end

  def self.count_georef
    @@statsrecord.georef_occurrences
  end

  def self.last_updated
    @@statsrecord.last_update
  end
end
