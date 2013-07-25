require 'net/http'
require 'nokogiri'
require 'pg'

dbHost = "dev"
dbPort = 5432
dbName=ARGV[0]
dbLogin=ARGV[1]
dbPasswd=ARGV[2]

def getCOLinfo(args)
  begin
  tags= ["url", "rank", "name_status"]
  webparams = Hash.new("unknown")

  url = URI.parse('http://www.catalogueoflife.org/col/webservice?'+args)
# puts "url=#{url}"
  res = Net::HTTP.get_response(url)
# puts "res=#{res}"
  doc = Nokogiri::XML(res.body)
  ele= doc.xpath(".//result")
  tags.each { |t| 
#   puts ele
  if !ele.at_xpath(t).nil?
    webparams[t]=ele.at_xpath(t)
  end
  }
  return webparams

  rescue URI::InvalidURIError
    puts "invalidURIError: #{args}"
    return webparams
  end

end


conn = PGconn.connect(dbHost, dbPort,"","", dbName, dbLogin, dbPasswd)
# read entire countries table
res = conn.exec("select id, name from scientificnames where col_done!=true order by id;")
res.each do |s|
#  puts "id=#{s['id']}, name=#{s['name']}"
#  if s[1].split(/ /).length < 3 then    
    webparams=getCOLinfo('name='+s['name'].gsub(/ /,'+'))
    if !webparams.empty?
#      puts  "name=#{s['name']} CoL says #{webparams}"
      sql= "update scientificnames set col_done=true "
      webparams.each { |key, value| sql << ", col_" + key + "='" + value + "'"}  
      sql << " where id=" + s['id'] ;
#         puts "#{sql}"
     conn.exec(sql)
    else
      puts  "name=#{s['name']} unknown to CoL"
    end
end

res.clear
conn.close





