class Provider < ActiveRecord::Base
  # Take care : some providers aren't linked to country (international iniatives providers)
  has_many :resources
  belongs_to :network

  belongs_to :country

  # Shared between country, provider and resource... Should be factorized.
  named_scope :for_search_select,
              :conditions => 'count IS NOT NULL'

  named_scope :from_country_id, lambda { |country_id| { :conditions => {:country_id => country_id} }}


end