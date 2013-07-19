

COPY  countries (name, code) FROM '/home/nnoe/websites/test_import_mdp/Countries_UTF8.txt' HEADER CSV DELIMITER '\t' NULL AS '';

UPDATE providers set country_id= c.id from countries c where c.code= isoCountryCode;


INSERT into instCodes (name) (select distinct  "Institution code" from gbif_occurrences);


INSERT into colCodes (name) (select distinct  "Collection code" from gbif_occurrences);


INSERT into scientificNames (name) (select distinct  "Scientific name (interpreted)" from gbif_occurrences);



INSERT into basisOfRecords (name) (select distinct  "Basis of record" from gbif_occurrences);




COPY  ranks FROM '/home/nnoe/websites/test_import_mdp/ranks_UTF8.txt' HEADER CSV DELIMITER '\t' NULL AS '';



update gbif_occurrences set 
		"Kingdom"= initcap("Kingdom"),
		"Phylum"= initcap("Phylum"),
		"Class"=initcap("Class"),
		"Order"=initcap("Order"),
		"Family"=initcap("Family"),
		"Genus"=initcap("Genus");
	

insert into flattaxons (k_name, p_name, c_name, o_name, f_name, g_name) (select  distinct on ("Kingdom", "Phylum", "Class", "Order", "Family", "Genus") "Kingdom", "Phylum", "Class", "Order", "Family", "Genus" from gbif_occurrences);

		
insert into taxons (rank_id,name) (
	select distinct  on (k_name) 0, k_name 
	from flattaxons where k_name is not null order by k_name
);
update flattaxons set k_id = t.id from taxons t where (t.name = k_name);
	 
insert into taxons (rank_id,name, parent_id) (
	select distinct  on (p_name, k_name) 1, p_name, k_id 
	from flattaxons where p_name is not null order by p_name	
);
update flattaxons set p_id = t.id from taxons t where (t.name = p_name);

insert into taxons (rank_id,name, parent_id) (
	select distinct  on (c_name, p_name, k_name) 2, c_name, coalesce (p_id, k_id) 
	from flattaxons where c_name is not null order by c_name	
);
update flattaxons set c_id = t.id from taxons t where (t.name = c_name);

insert into taxons (rank_id,name, parent_id) (
	select distinct  on (o_name, c_name, p_name, k_name) 3, o_name, coalesce (c_id, p_id, k_id) 
	from flattaxons where o_name is not null order by o_name	
);
update flattaxons set o_id = t.id from taxons t where (t.name = o_name);

insert into taxons (rank_id,name, parent_id) (
	select distinct  on (f_name, o_name, c_name, p_name, k_name) 4, f_name, coalesce (o_id, c_id, p_id, k_id) 
	from flattaxons where f_name is not null order by f_name	
);
update flattaxons set f_id = t.id from taxons t where (t.name = f_name);

insert into taxons (rank_id,name, parent_id) (
	select distinct  on (g_name, f_name, o_name, c_name, p_name, k_name) 5, g_name, coalesce (f_id, o_id, c_id, p_id, k_id) 
	from flattaxons where g_name is not null order by g_name	
);
update flattaxons set g_id = t.id from taxons t where (t.name = g_name);

update flattaxons set k_name='' where k_name is null;
update flattaxons set p_name='' where p_name is null;
update flattaxons set c_name='' where c_name is null;
update flattaxons set o_name='' where o_name is null;
update flattaxons set f_name='' where f_name is null;
update flattaxons set g_name='' where g_name is null;
alter table gbif_occurrences add column ft_id int;
update gbif_occurrences set ft_id=ft.id from flattaxons ft where (ft.k_name = coalesce("Kingdom",'') and ft.p_name= coalesce("Phylum",'') and ft.c_name= coalesce("Class",'') 
		and ft.o_name=coalesce("Order",'') and ft.f_name=coalesce("Family",'') and ft.g_name=coalesce("Genus",''));




			

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
	substr(occ."GBIF portal url",34)::int,
	bor.id,
	prov.id,
	res.id,
	occ."Date collected",
	inst.id,
	coll.id,
	occ."Catalogue No",
	occ."Last indexed",
	occ."Scientific name",
	sn.id,
	ft.k_id,
	ft.p_id,
	ft.c_id,
	ft.o_id,
	ft.f_id,
	ft.g_id,
---	occ."Locality",
	substr(occ."Locality",0,1024),
	country.id,
	occ."Latitude" ,
	occ."Longitude" ,
	round(occ."Coordinate precision"::numeric,0) ,
	occ."Cell id",
	occ."Centi cell id",
	GeomFromText( 'POINT(' || occ."Longitude" || ' ' || occ."Latitude" || ')', 4326)

 from gbif_occurrences occ
 LEFT JOIN basisOfRecords bor on (bor.name = occ."Basis of record")
 LEFT JOIN providers prov on (prov.name = occ."Data publisher" )
 LEFT JOIN resources res on (res.name = occ."Dataset" and res.provider_id = prov.id) 
 LEFT JOIN instCodes inst on(inst.name = occ."Institution code")
 LEFT JOIN colCodes coll on(coll.name = occ."Collection code")
 LEFT JOIN scientificNames sn on (sn.name = occ."Scientific name (interpreted)")
 LEFT JOIN countries country on (country.name = upper (occ."Publisher country"))
 LEFT JOIN flattaxons ft on (ft.id = occ.ft_id)
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

update providers set count = c.count from (select provider_id, count(provider_id) from occurrences group by provider_id) as c where providers.id=c.provider_id;
update resources set count = c.count from (select resource_id, count(resource_id) from occurrences group by resource_id) as c where resources.id=c.resource_id;
alter table countries add column count integer;
update countries set count = c.count from (select providercountry_id, count(providercountry_id) from occurrences group by providercountry_id) as c where id=c.providercountry_id;
	
		
create or replace view georef_occ as
select * from occurrences where coordinates is not null;
			