class Country < ActiveRecord::Base
  has_many :providers
  has_many :resources, :through => :providers

  # Shared between country, provider and resource... Should be factorized.
  named_scope :for_search_select, 
              :conditions => 'count IS NOT NULL'

end
