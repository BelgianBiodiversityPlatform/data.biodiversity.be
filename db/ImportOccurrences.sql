DROP TABLE gbif_occurrences;
CREATE TABLE gbif_occurrences(
	"Data publisher" 	text,
	"Dataset" 	text,
	"Dataset Rigths"	text,
	"Collector name" 	text,
	"Collector number" 	text,
	"Field number" 	text,
	"GUID" 	text,
	"Date collected"	date,
	"Institution code" 	text,
	"Collection code" 	text,
	"Catalogue No" 	text,
	"Basis of record" 	text,
	"Image url" 	text,
	"Last indexed" 	date,
	"Identifier" 	text,
	"Identification date"	date,
	"Scientific name" 	text,
	"Author" 	text,
	"Scientific name (interpreted)" 	text,
	"Kingdom" 	text,
	"Phylum" 	text,
	"Class" 	text,
	"Order" 	text,
	"Family" 	text,
	"Genus" 	text,
	"Country" 	text,
	"Country (interpreted)" 	text,
	"Locality" 	text,
	"County" 	text,
	"Continent or Ocean" 	text,
	"State/Province" 	text,
	"Region" 	text,
	"Publisher country" 	text,
	"Latitude" 	float,
	"Longitude" 	float,
	"Coordinate precision" text,
	"Cell id"	int,
	"Centi cell id"	int,
	"Min depth"	text,
	"Max depth"	text,
	"Max depth2"	text,
	"Min altitude"	text,
	"Max altitude"	text,
	"Altitude precision"	text,
	"GBIF portal url"	 	text,
	"GBIF webservice url" 	text
)WITH OIDS;
create unique index guid_idx on gbif_occurrences ("GUID");
	
--- Data occurring in Mauritania
COPY  gbif_occurrences		FROM '/home/aheugheb/db/BDP/occurrence-search/MR/2010-02-25/occurrence-search.txt' HEADER CSV DELIMITER '\t' QUOTE '"' NULL AS '';

--- Data occurring in Belgium
COPY  gbif_occurrences		FROM '/home/aheugheb/db/BDP/occurrence-search/BE/2010-07-27/occurrence-search-DIPOL.txt' HEADER CSV DELIMITER '\t' QUOTE '"' NULL AS '';
COPY  gbif_occurrences		FROM '/home/aheugheb/db/BDP/occurrence-search/BE/2010-10-19/occurrence-search-1700-1957.csv' HEADER CSV DELIMITER ',' QUOTE '"' NULL AS '';
COPY  gbif_occurrences		FROM '/home/aheugheb/db/BDP/occurrence-search/BE/2010-10-19/occurrence-search-1958-2010.csv' HEADER CSV DELIMITER ',' QUOTE '"' NULL AS '';


alter table gbif_occurrences drop column ft_id;
COPY  gbif_occurrences		FROM '/home/aheugheb/db/BDP/BeBIFData/10969-BR-IFBL/occurrence-search-1269960535989.txt' HEADER CSV DELIMITER '\t' QUOTE '"' NULL AS '';

---within Belgium bounding box (2.5-6.4 East, 49.5-51.5 North)
COPY  gbif_occurrences		FROM '/home/aheugheb/db/BDP/occurrence-search/14-12-2009/occurrence-search-1260786910312.txt' HEADER CSV DELIMITER '\t' QUOTE '@' NULL AS '';
select "Country (interpreted)", count (*) from  gbif_occurrences group by "Country (interpreted)";




update gbif_occurrences set "Coordinate precision" = split_part("Coordinate precision",'.', 1);
update gbif_occurrences set			
	"Kingdom" = initcap("Kingdom"),
	"Phylum" = initcap("Phylum"),
	"Class" = initcap("Class"),
	"Order" = initcap("Order"),
	"Family" = initcap("Family"),
	"Genus" = initcap("Genus");