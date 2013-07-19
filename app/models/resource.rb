class Resource < ActiveRecord::Base
  belongs_to :provider

  # Shared between country, provider and resource... Should be factorized.
  named_scope :for_search_select,
              :conditions => 'count IS NOT NULL'
  named_scope :from_provider_id, lambda {|provider_id| {:conditions => {:provider_id => provider_id}}}
  named_scope :from_country_id, lambda  { |country_id|
                                          # we have to go trough providers
                                          prov = Provider.from_country_id(country_id)
                                          { :conditions => {:provider_id => prov.map{|p| p.id}} }
                                        }

end
