DROP TABLE Countries CASCADE;
CREATE TABLE countries (
 id			serial primary key,
 name	    varchar(256),
 code  varchar(4)
);


DROP TABLE networks CASCADE;
CREATE TABLE networks (
  	id				int primary key, -- GBIF key
  	name	        varchar(64) NOT NULL,
  	shortIdentifier	varchar(64) NOT NULL,
	websiteUrl		varchar(64),
	occurrenceCount	int,
	georeferencedOccurrenceCount int
);

DROP TABLE providers CASCADE;
CREATE TABLE providers (
  	id				int primary key, -- GBIF key
  	name	        varchar(256) NOT NULL,
	websiteUrl		varchar(256),
	taxonConceptCount 	int,
	occurrenceCount		int,
	georeferencedOccurrenceCount int,
	isoCountryCode	char(2),
	country_id 		int references countries,
	created			timestamp,
	modified		timestamp,
	count			int
);

DROP TABLE resources CASCADE;
CREATE TABLE resources (
  	id				int primary key, -- GBIF key
  	provider_id		int references providers,
	name	        varchar(256) NOT NULL,
	defaultBasisOfRecord	varchar(64),
	created			timestamp,
	modified		timestamp,
  	count 			int	
);

DROP TABLE instCodes CASCADE;
CREATE TABLE instCodes (
	 id			serial primary key,
	 name	    varchar(256) NOT NULL
);

DROP TABLE colCodes CASCADE;
CREATE TABLE colCodes (
 	id			serial primary key,
 	name	    varchar(256) NOT NULL
);		

DROP TABLE scientificNames CASCADE;
CREATE TABLE scientificNames (
 id			serial primary key,
 name	    varchar(256) NOT NULL
);

DROP TABLE basisOfRecords CASCADE;
CREATE TABLE basisOfRecords (
 id			serial primary key,
 name	    varchar(256) NOT NULL
);
DROP TABLE ranks CASCADE;
CREATE TABLE ranks (
 id		int primary key,
 name	    varchar(256)
);
DROP TABLE taxons CASCADE;
CREATE TABLE taxons (
 id		serial primary key,
 rank_id	int references ranks,
 parent_id 	int references taxons,
 name	    varchar(256)
);

#DROP table flattaxons;
#CREATE table flattaxons (
#			id serial primary key,
#			k_id int,
#			p_id int,
#			c_id int,
#			o_id int,
#			f_id int,
#			g_id int,
#			k_name varchar(256),
#			p_name varchar(256),
#			c_name varchar(256),
#			o_name varchar(256),
#			f_name varchar(256),
#			g_name varchar(256)	
#);

DROP TABLE occurrences CASCADE;
CREATE TABLE occurrences(
	id				serial primary key,
	key				int unique,-- GBIF key
	basisOfRecord_id int references basisOfRecords,	
	provider_id		int references providers,
	resource_id		int references resources,
	date_collected	date,
	instcode_id		int references instcodes,
	colcode_id 		int references colcodes,
	catalogue_no 		varchar(64),
	last_indexed 		date,
	scientific_name 	varchar(256),
	scientificName_id 	int references scientificnames,
	tKingdom_id 	int references taxons,
	tPhylum_id 		int references taxons,
	tClass_id 		int references taxons,
	tOrder_id 		int references taxons,
	tFamily_id 		int references taxons,
	tGenus_id 		int references taxons,
	locality 		varchar(1024),
	providerCountry_id int references countries,
	latitude 		float,
	longitude 		float,
	coordinate_precision float,
	cell_id			int,
	centi_cell_id	int,
	coordinates		Point
);