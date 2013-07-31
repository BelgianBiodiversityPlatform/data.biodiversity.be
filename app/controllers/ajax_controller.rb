class AjaxController < ApplicationController

  # Called by AJAX request for the 'show results on map" functionality
  # Returned data should conform to :
  # render :json => {
  #                id_of_occurrence1 => {:lat => 50.819722, :lon => 4.3975},
  #                id_of_occurrence2 => {:lat => 50.465556, :lon => 4.866556}
  #                }
  def get_geodata
    # Filter the results
    occ = filter_occurrences(decode_json_filters(params[:filters]))
    occ = occ.scoped :conditions => 'coordinates IS NOT NULL' # of course, only the georef are interesting here

    rv = {}
    occ.each do |row|
      a = {row.id => {:lat => row.latitude, :lon => row.longitude, :precision => row.coordinate_precision}}
      rv.merge!(a)
    end

    render :json => rv
  end

  def export_occurrences
    filename = 'data.' + params[:format] # kml || csv

    content_type = case params[:format]
      when 'csv' then 'text/csv'
      when 'kml' then 'application/vnd.google-earth.kml+xml'
    end

    headers.merge!( 'Content-Type' => content_type,
                    'Content-Disposition' => "attachment; filename=\"#{filename}\"",
                    'Content-Transfer-Encoding' => 'binary')

    render :text => proc { |response, output|
      response.write Occurrence.csv_titles << "\n" if params[:format] == 'csv'
      response.write kml_header if params[:format] == 'kml'

      scope = filter_occurrences(decode_json_filters(params[:filters]))
      scope = scope.scoped :include => [ :resource, :colcode, :instcode ]

      scope.find_each() do |occ|
        case params[:format]
          when 'csv' then output.write(occ.to_csv + "\n")
          when 'kml' then output.write(occ.to_kml)
        end
      end
      
      response.write kml_footer if params[:format] == 'kml'
    }
  end

  # Small helper for ordering results, taking parameter from AJAX
  def process_order_clause(value_from_ajax)
    if value_from_ajax == 'occurrences.coordinates' # Cannot sort directly on a POINT field
      'CASE WHEN occurrences.coordinates IS NULL THEN 1 ELSE 0 END'
    else
      value_from_ajax
    end
  end


  # To get paginated, sorted AJAX occurrences table.
  # Out : render a partial to replace a div's content.
  def show_occurrences

    page_num = params[:page_num].to_i
    cgrf = case(params[:georef_create_link])
      when 'true' then true
      when 'false' then false
    end

    # Filter the results
    filters = decode_json_filters(params[:filters])
    
    occ = filter_occurrences(filters)
    
    
    # Count them BEFORE applying limit and offset
    total_results = occ.count('key')
    
    # Optimize: if search is performed through a map => no need to calculate georeferenced counter
    if filters.has_key?('polygon')
      total_georeferenced_results = total_results
    else
      total_georeferenced_results = occ.georeferenced.count
    end  
    
    
    # Limit them
    occ = occ.scoped :include => [:provider, :resource, :country]
    occ = occ.scoped :limit => RESULTS_PER_PAGE
    occ = occ.scoped :offset => OccurrencesContainer::calculate_offset(page_num)
    occ = occ.scoped :order => process_order_clause(params[:sort_field])
    
    
    results = OccurrencesContainer.new(occ, total_results, total_georeferenced_results, page_num)

    render :partial => 'results', :object => results, :locals => {:clickable_georef => cgrf, :mode => :occurrences_table}
  end

  def show_specieslist
    # We apply the same filters as for an occurrences search
    scope = filter_occurrences(decode_json_filters(params[:filters]))
    scope = scope.scoped :select => 'scientificname_id, COUNT(*) as cpt'
    scope = scope.scoped :group => 'scientificname_id'
    #scope = scope.scoped :include => :scientificname

    # Get all the needed scientific names and store them in an {sn_id => sn_name, ... } hash
    sn_table = {}
    Scientificname.all(:select => 'id, name', :conditions => "id IN (#{scope.map{|s| s.scientificname_id}.join(',')})").each {|sn| sn_table[sn.id] = sn.name}

    results = []

    # Join them to get the results
    scope.each do |sn|
      results << {:name => sn_table[sn.scientificname_id], :counter => sn.cpt}
    end

    # And render the results table
    render :partial => 'results', :object => results, :locals => {:mode => :species_list}
  end

  private

  def decode_json_filters(raw_filters)
    return ActiveSupport::JSON.decode(raw_filters)
  end
  
  def dedouble_words_if_necessary(original_filter)
    # With some (8.4) version of PostgreSQL, one word search terms refuse to use the index:
    # "Canis" -> no index, slow
    # "Canis Canis" -> same results, but fast cause index are used.
    # this method just perform this stupid transformation
    bugged_postgres = true
    
    if bugged_postgres and (original_filter.scan(/[\w-]+/).size == 1)
      original_filter + " " + original_filter
    else
      original_filter
    end
    
  end

  # filters is JSON encoded, one key per filter
  def filter_occurrences(filters)

    scope = Occurrence.scoped({})

    #scope = scope.scoped :conditions => ['scientific_name ILIKE ?', "%#{filters['sn']}%"] if filters.has_key?('sn')
    if filters.has_key?('sn')
      filter_sn = dedouble_words_if_necessary(filters['sn'])
      
      scope = scope.scoped :conditions => ["to_tsvector('english', scientific_name) @@ plainto_tsquery(?)", filter_sn]
    end
    
    
    scope = scope.scoped :conditions => ['locality ILIKE ?', "%#{filters['locality']}%"] if filters.has_key?('locality')
    #scope = scope.scoped :conditions => ["contains (ST_Transform(ST_GeomFromText(?,96), 4326), ST_SetSRID(ST_Point(occurrences.longitude, occurrences.latitude),4326))", filters['polygon']] if filters.has_key?('polygon')
    scope = scope.scoped :conditions => ["ST_contains (ST_GeomFromText(?,900913), occurrences.coordinates_google)", filters['polygon']] if filters.has_key?('polygon')
    
    scope = scope.scoped :conditions => ['occurrences.providercountry_id = ?', filters['providercountry_id']] if filters.has_key?('providercountry_id')
    scope = scope.scoped :conditions => ['occurrences.provider_id = ?', filters['provider_id']] if filters.has_key?('provider_id')
    scope = scope.scoped :conditions => ['occurrences.resource_id = ?', filters['resource_id']] if filters.has_key?('resource_id')
    scope = scope.scoped :conditions => ['occurrences.date_collected <= ?', filters['collected_before']] if filters.has_key?('collected_before')
    scope = scope.scoped :conditions => ['occurrences.date_collected >= ?', filters['collected_after']] if filters.has_key?('collected_after')

    # Minimums and Maximums for lon/lat
    scope = scope.scoped :conditions => ['occurrences.latitude >= ?', filters['min_lat']] if filters.has_key?('min_lat')
    scope = scope.scoped :conditions => ['occurrences.latitude <= ?', filters['max_lat']] if filters.has_key?('max_lat')
    scope = scope.scoped :conditions => ['occurrences.longitude >= ?', filters['min_lon']] if filters.has_key?('min_lon')
    scope = scope.scoped :conditions => ['occurrences.longitude <= ?', filters['max_lon']] if filters.has_key?('max_lon')

    scope
  end

  def kml_header
    '<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://www.opengis.net/kml/2.2"><Document>'
  end

  def kml_footer
    '</Document></kml>'
  end

end
