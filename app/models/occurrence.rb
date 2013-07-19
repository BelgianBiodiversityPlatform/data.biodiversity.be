class Occurrence < ActiveRecord::Base
  belongs_to :resource
  belongs_to :provider
  belongs_to :country, :foreign_key => 'providercountry_id'
  belongs_to :instcode
  belongs_to :colcode # FK always present in occurrences (on june 16, 2009)
  belongs_to :basisofrecord
  belongs_to :scientificname

  def georef?
    coordinates ? true : false
  end

  named_scope :georeferenced, :conditions => 'coordinates IS NOT NULL'

  # fields must be coherent between this and self.csv_titles
  def to_csv
    fields = []

    fields << '"' + key.to_s + '"'
    fields << '"' + scientific_name + '"'
    fields << '"' + (locality || '')  + '"'
    fields << '"' + (resource ? resource.name : '') + '"'
    fields << '"' + (georef? ? 'TRUE':'FALSE') +'"'
    fields << '"' + (date_collected ? date_collected.to_s : '') + '"'
    fields << '"' + (latitude ? latitude.to_s : '') + '"'
    fields << '"' + (longitude ? longitude.to_s : '') + '"'
    fields << '"' + (colcode ? colcode.name : '') + '"'
    fields << '"' + (instcode ? instcode.name : '') + '"'
    fields << '"' + (catalogue_no ? catalogue_no.to_s : '') + '"'

    fields.join(CSV_SEPARATOR)
  end

  # fields must be coherent between this and to_csv
  def self.csv_titles
    [ 'GBIF key',
      'Scientific name',
      'Locality',
      'Resource',
      'Georeferenced ?',
      'Collection date',
      'Latitude',
      'Longitude',
      'Collection code',
      'Institution Code',
      'Catalog Number'
    ].join(CSV_SEPARATOR)
  end

  def to_kml
    if georef?
      txt = "<Placemark>\n"
      txt << "<name><![CDATA[#{scientific_name} (occurrence #{key})]]></name>\n"
      txt << "<description>Data from #{APP_NAME}.</description>\n"
      txt << "<Point>\n"
        txt << '<coordinates>' + longitude.to_s + ',' + latitude.to_s + '</coordinates>' + "\n"
      txt << "</Point>\n"
      txt << "</Placemark>\n"
    else
      txt = ''
    end
    txt
  end

end
