--DROP TABLE ranks CASCADE;
CREATE TABLE ranks (
 id		int primary key,
 name	    varchar(256)
);
COPY  ranks FROM '/home/aheugheb/db/BDP/ranks_UTF8.txt' HEADER CSV DELIMITER '\t' NULL AS '';

--DROP TABLE taxons CASCADE;
CREATE TABLE taxons (
 id		serial primary key,
 rank_id	int references ranks,
 parent_id 	int references taxons,
 name	    varchar(256)
);

update gbif_occurrences set 
		"Kingdom"= initcap("Kingdom"),
		"Phylum"= initcap("Phylum"),
		"Class"=initcap("Class"),
		"Order"=initcap("Order"),
		"Family"=initcap("Family"),
		"Genus"=initcap("Genus");
	
--DROP table flattaxons;
CREATE table flattaxons (
			id serial primary key,
			k_id int,
			p_id int,
			c_id int,
			o_id int,
			f_id int,
			g_id int,
			k_name varchar(256),
			p_name varchar(256),
			c_name varchar(256),
			o_name varchar(256),
			f_name varchar(256),
			g_name varchar(256)	
);
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


