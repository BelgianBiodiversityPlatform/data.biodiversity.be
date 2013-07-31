update gbif_export set "latitude" = replace("latitude", ',', '.'), "longitude" = replace("longitude", ',', '.');

-- countries and ranks
COPY countries (name, code) FROM '/home/aheugheb/db/BDP/Countries_UTF8.txt' HEADER CSV DELIMITER '\t' NULL AS '';
COPY ranks FROM '/home/aheugheb/db/BDP/ranks_UTF8.txt' HEADER CSV DELIMITER '\t' NULL AS '';


-- Providers, resources, institutions and collections codes

INSERT into providers (id,name, country_id) (
	select distinct  on ("data_provider_id") "data_provider_id", "data_provider", country.id from gbif_export occ
	LEFT JOIN countries country on (country.code = occ."provider_country")
);
INSERT into resources (id,name, provider_id) (select distinct  on ("data_resource_id") "data_resource_id", "dataset", "data_provider_id" from gbif_export);

INSERT into instCodes (name) (select distinct  "institution_code" from gbif_export);

INSERT into colCodes (name) (select distinct  "collection_code" from gbif_export);

INSERT into scientificNames (name) (select distinct  "scientific_name" from gbif_export);

INSERT into basisOfRecords (name) (select distinct  "basis_of_record" from gbif_export);


-- Taxonomy
		
insert into taxons (rank_id,name) (
	select distinct  on (k_name) 0, k_name 
	from flattaxons where k_name is not null order by k_name
);
	 
insert into taxons (rank_id,name, parent_id) (
	select distinct  on (p_name, k_name) 1, p_name, k_id 
	from flattaxons where p_name is not null order by p_name	
);

insert into taxons (rank_id,name, parent_id) (
	select distinct  on (c_name, p_name, k_name) 2, c_name, coalesce (p_id, k_id) 
	from flattaxons where c_name is not null order by c_name	
);

insert into taxons (rank_id,name, parent_id) (
	select distinct  on (o_name, c_name, p_name, k_name) 3, o_name, coalesce (c_id, p_id, k_id) 
	from flattaxons where o_name is not null order by o_name	
);

insert into taxons (rank_id,name, parent_id) (
	select distinct  on (g_name, o_name, c_name, p_name, k_name) 5, g_name, coalesce (o_id, c_id, p_id, k_id) 
	from flattaxons where g_name is not null order by g_name	
);



---Occurrences 
INSERT INTO  occurrences ( 
	 key,
	 basisOfRecord_id,
     provider_id,
	 resource_id,
	 date_collected,
	 instcode_id,
	 colcode_id,
	 catalogue_no,
	 last_indexed,
	 scientific_name,
	 scientificName_id,
	 tKingdom_id,
	 tPhylum_id,
	 tClass_id,
	 tOrder_id,
	 tFamily_id,
	 tGenus_id,
	 locality,
	 providerCountry_id,
	 latitude,
	 longitude,
	 coordinate_precision,
	 cell_id,
	 centi_cell_id,
	 coordinates
	)
		 SELECT 
			occ."occurrence_id",
			bor.id,
			occ.data_provider_id,
			occ.data_resource_id,
			CASE
			WHEN (occ."date_collected" ~ E'^\\d{4}-\\d{2}-\\d{2}') THEN to_date (occ."date_collected", 'YYYY-MM-DD')
			ELSE NULL END as date_collected,
			inst.id,
			coll.id,
			occ."catalogue_number",
			occ."last_indexed",
			occ."scientific_name",
			sn.id,
			tk.id,
			tp.id,
			tc.id,
			tor.id,
			NULL,
			tg.id,
			substr(occ."locality",0,1024),
			country.id,
			
            CASE
                WHEN (occ.latitude ~ E'^\\d+\\.?\\d+') 
                THEN occ."latitude"::float
                ELSE NULL
            END as latitude,
            
            CASE 
                WHEN (occ.longitude ~ E'^\\d+\\.?\\d+')
                THEN occ."longitude"::float
                ELSE NULL
            END as longitude,    

			CASE 
			    WHEN (occ.coordinate_precision ~ E'^\\d+\\.?\\d+') 
                THEN round(occ."coordinate_precision"::numeric,0) 
			    ELSE NULL 
            END as coordinate_precision,

			occ."cell_id",
			occ."centi_cell_id",

            CASE
                WHEN ((occ.latitude ~ E'^\\d+\\.?\\d+') AND (occ.longitude ~ E'^\\d+\\.?\\d+'))
                THEN
                    point(occ."longitude"::float, occ."latitude"::float)
                ELSE NULL
            END as coordinates

		 from gbif_export occ
		 LEFT JOIN basisOfRecords bor on (bor.name = occ."basis_of_record")
		 LEFT JOIN instCodes inst on(inst.name = occ."institution_code")
		 LEFT JOIN colCodes coll on(coll.name = occ."collection_code")
		 LEFT JOIN scientificNames sn on (sn.name = occ."scientific_name")
		 LEFT JOIN countries country on (country.code = upper (occ."provider_country"))
		 LEFT JOIN taxons tk on tk.rank_id=0 and tk.name= occ."kingdom"
		 LEFT JOIN taxons tp on tp.rank_id=1 and tp.name= occ."phylum" and tp.parent_id= tk.id
		 LEFT JOIN taxons tc on tc.rank_id=2 and tc.name= occ."class" and tc.parent_id = tp.id
		 LEFT JOIN taxons tor on tor.rank_id=3 and tor.name= occ."order_rank" and tor.parent_id = tc.id
		 LEFT JOIN taxons tg on tg.rank_id=5 and tg.name= occ."genus" and tg.parent_id = tor.id
;

--- DO THIS...	


create index coordinates_idx on occurrences using GIST (coordinates);
create index basisOfRecord_id_idx on occurrences (basisOfRecord_id);
create index provider_id_idx on occurrences (provider_id);
create index resource_id_idx on occurrences (resource_id);
create index instcode_id_idx on occurrences (instcode_id);
create index colcole_id_idx on occurrences (colcode_id);
create index tkingdom_id_idx on occurrences (tkingdom_id);
create index tphylum_id_idx on occurrences (tphylum_id);
create index tclass_id_idx on occurrences (tclass_id);
create index torder_id_idx on occurrences (torder_id);
create index tfamily_id_idx on occurrences (tfamily_id);
create index tgenus_id_idx on occurrences (tgenus_id);

alter table countries add column count integer;

update providers set count = c.count from (select provider_id, count(provider_id) from occurrences group by provider_id) as c where providers.id=c.provider_id;
update resources set count = c.count from (select resource_id, count(resource_id) from occurrences group by resource_id) as c where resources.id=c.resource_id;
update countries set count = c.count from (select providerCountry_id, count(providerCountry_id) from occurrences group by providerCountry_id) as c where id=c.providerCountry_id;
		
create or replace view georef_occ as select * from occurrences where coordinates is not null;
			
alter table scientificnames add column col_url varchar(128);
alter table scientificnames add column col_rank varchar(64);
alter table scientificnames add column col_name_status varchar(64);
alter table scientificnames add column col_done boolean;
update scientificnames set col_done=false;
	
-- Added BIRDS and HABITAT Directives Species table

-- Hmmm, disable it because we don't use it so far and I'm not sure where AnnexSpeciesPresence table/data comes from...
--alter table "AnnexSpeciesPresence" add column id serial;
--alter table "AnnexSpeciesPresence" add constraint asp_id primary key (id);
--alter table scientificnames add column annexSpecies_id integer references "AnnexSpeciesPresence";
--update scientificnames set annexSpecies_id = tmp.asp_id 
--from (select sn.id, asp.id as asp_id from scientificnames sn join "AnnexSpeciesPresence" asp on asp."speciesName"= sn.name) as tmp
--where scientificnames.id = tmp.id;
	
alter table resources add column geo_count integer;
update resources set geo_count = c.count from (select resource_id, count(resource_id) from occurrences where latitude is not null group by resource_id) as c where resources.id=c.resource_id;

--alter table resources add column gbif_description text;
--alter table resources add column gbif_taxonConceptCount integer;
--alter table resources add column gbif_speciesCount integer;
--alter table resources add column gbif_occurrenceCount integer;
--alter table resources add column gbif_georeferencedOccurrenceCount integer;
--alter table resources add column gbif_done boolean;

--select * from resources where provider_id in (12, 107, 147, 260)  order by id;
