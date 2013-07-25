-- NEW WAY using Belgian Data Slice--
1/Load GBIF Export
Run ImportGBIFExport.sql

2/Create tables
Run GBIFCreateSchema.sql

3/ Populate occurrences
Run Populate_from_export.sql 

4/ add Catalog of Life info (network, providers, resources) using webservices
ruby -rubygems colWebServices.rb <db> <user> <psswd>


--OLD WAY using GBIF webportal--
1/ From GBIF data portal
1.1/Extract occurrences
occurrences_search form http://data.gbif.org/countries/BE
click Occurrences, then download Spreadsheet of Results

!!!Watch out for unmatched " strings and tab within text fields!!!

1.2/Extract metadata
network_list.xml obtained by http://data.gbif.org/ws/rest/network/list
provider_list.xml obtained by http://data.gbif.org/ws/rest/provider/list

2/ ImportOccurrences into gbif_occurrences table (DarwinCore)
Run ImportOccurrences.sql

3/ Metadata

3.1/ Create tables
Run GBIFCreateSchema.sql

3.2/ Populate metadata tables (network, providers, resources) from XML files
ruby -rubygems ImportMetadata.rb <db> <user> <psswd>

4/ Occurrences
Run Populate.sql 


5/ add Catalog of Life info (network, providers, resources) using webservices
ruby -rubygems colWebServices.rb <db> <user> <psswd>