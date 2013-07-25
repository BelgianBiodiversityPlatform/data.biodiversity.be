require 'net/http'
require 'rexml/document'
require "postgres"





dbHost = "canis"
dbPort = 5432
dbName=ARGV[0]
dbLogin=ARGV[1]
dbPasswd=ARGV[2]

def getGBIFinfo(args)
  begin
  tags= ["gbif:taxonConceptCount", "gbif:speciesCount", "gbif:occurrenceCount", "gbif:georeferencedOccurrenceCount"]
  webparams = Hash.new("unknown")
  url = URI.parse('http://data.gbif.org/ws/rest/resource/get/'+args)
  puts "requesting #{url}"
  res = Net::HTTP.get_response(url)
  doc = REXML::Document.new(res.body)
  if doc.root.has_elements?()
    then
    dps=doc.root.elements['gbif:dataProviders']
    dp=dps.elements['gbif:dataProvider']
    drs=dp.elements['gbif:dataResources']
    dr=drs.elements['gbif:dataResource']
#    puts "#{dr}"
    tags.each { |t| if !dr.elements[t].nil? then webparams[t.split(/:/)[1]]=dr.elements[t].text end }
  end
  return webparams

  rescue URI::InvalidURIError
    puts "invalidURIError: #{args}"
    return webparams
  rescue Timeout::Error
    puts "TimeoutError: #{args}"
    return webparams
  end

end


conn = PGconn.connect(dbHost, dbPort,"","", dbName, dbLogin, dbPasswd)
# read entire countries table
res = conn.exec("select id from resources where gbif_done!=true order by id;")
res.each do |s|
    webparams=getGBIFinfo(s[0])
#    if !webparams.empty?

      sql= "update resources set gbif_done=true "
      webparams.each { |key, value| sql << ", gbif_" + key + "='" + value + "'"}  
      sql << " where id=" + s[0] ;
#      puts "#{sql}"
      conn.exec(sql)
#    else
#      puts  "name=#{s[0]} unknown to GBIF"
#    end
end

res.clear
conn.close





