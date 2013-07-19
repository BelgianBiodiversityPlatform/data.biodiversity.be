require 'rexml/document'
require "postgres"

# Needs two xml files obtained from GBIF webservices:

# GBIF networks
n_tags= ["gbif:name","gbif:shortIdentifier","gbif:websiteUrl","gbif:occurrenceCount", "gbif:georeferencedOccurrenceCount"]

# GBIF providers
p_tags= ["gbif:name","gbif:websiteUrl","gbif:taxonConceptCount","gbif:occurrenceCount", "gbif:georeferencedOccurrenceCount", "gbif:isoCountryCode", "gbif:created", "gbif:modified"]

# GBIF resources
r_tags= ["gbif:name", "gbif:defaultBasisOfRecord","gbif:created", "gbif:modified"]



def  insert(xml, table_name, tags)
  puts "#{table_name} key= #{xml.attributes['gbifKey']}"
    col="id"
    value=xml.attributes['gbifKey']
    tags.each do |tag|
      if !xml.elements[tag].nil? && !xml.elements[tag].text.nil?
        col << ', ' + tag.split(':')[1]
        value << ', \'' + xml.elements[tag].text.gsub(/(['])/, '\\\\\1') + '\''
  #      puts "#{tag}= #{xml.elements[tag].text}"
      end
    end
    sql= 'insert into '+ table_name + ' ('+ col +') VALUES (' + value + ');'
#    puts sql
    return sql
end

def  insert_with_fkey(xml, table_name, tags, fkey_xml, fkey_name)
  puts "#{table_name} key= #{xml.attributes['gbifKey']}"
  col="id, "+ fkey_name+"_id"
  value=xml.attributes['gbifKey'] + ', ' + fkey_xml.attributes['gbifKey']
  tags.each do |tag|
    if !xml.elements[tag].nil? && !xml.elements[tag].text.nil?
      col << ', ' + tag.split(':')[1]
      value << ', \'' + xml.elements[tag].text.gsub(/(['])/, '\\\\\1') + '\''
  #      puts "#{tag}= #{xml.elements[tag].text}"
    end
  end
  sql= 'insert into '+ table_name + ' ('+ col +') VALUES (' + value + ');'
#  puts sql
  return sql
end

dbHost = "localhost"
dbPort = 5432
dbName=ARGV[0]
dbLogin=ARGV[1]
dbPasswd=ARGV[2]
conn = PGconn.connect(dbHost, dbPort, "", "", dbName, dbLogin, dbPasswd)

doc = REXML::Document.new(File.open("network_list.xml"))
puts "Processing GBIF networks..."
doc.root.elements.each("//gbif:resourceNetworks/gbif:resourceNetwork") do |network|
  sql=insert(network, "networks",n_tags)
  conn.exec(sql)
end

doc = REXML::Document.new(File.open("provider_list.xml"))
puts "Processing GBIF providers..."
doc.root.elements.each("//gbif:dataProviders/gbif:dataProvider") do |dp|
  sql=insert(dp, "providers",p_tags)
  conn.exec(sql)
end

doc = REXML::Document.new(File.open("provider_list.xml"))
puts "Processing GBIF resources..."
doc.root.elements.each("//gbif:dataProviders/gbif:dataProvider") do |dp|
  dp.elements.each("gbif:dataResources/gbif:dataResource") do |dr|
    sql=insert_with_fkey(dr, "resources", r_tags, dp, "provider")
    conn.exec(sql)
  end
end

conn.close()
