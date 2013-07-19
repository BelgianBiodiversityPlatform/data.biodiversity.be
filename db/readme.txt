1/ From GBIF dat portal
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