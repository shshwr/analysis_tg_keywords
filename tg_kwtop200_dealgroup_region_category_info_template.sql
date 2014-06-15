use tuangou;
insert overwrite table tg_kwtop200_dealgroup_region_category_info partition(dt='yyyy-mm-dd') 
select
	id_regionName_info.dealgroupid,
	dealgroupshorttitle,
	dealgrouptitledesc,
	regionname,
	concat_ws('|',collect_set(categoryNameInfo.name)) as category
from	
	(
		select 
			d_r_info.dealgroupid,
			dealgroupshorttitle,
			dealgrouptitledesc,
			regionname,
			categoryid
		from
		(
			select 
				dealgroupid,
				dealgroupshorttitle,
				dealgrouptitledesc,
				regionname
			from
				tg_kwtop200_dealgroup_region_info
			where
				dt='yyyy-mm-dd'
		)d_r_info
		left outer join
		(
			select 
				dealgroupid,categoryid
			from
				bi.dpods_tg_navidealcategory 
			where 
				hp_statdate='yyyy-mm-dd' and ismain=1
		)categoryIdInfo
		on d_r_info.dealgroupid=categoryIdInfo.dealgroupid
	)id_regionName_info
	left outer join
	(
		select 
			id,name
		from
			bi.dpods_tg_navicategory 
		where 
			hp_statdate='yyyy-mm-dd'
	)categoryNameInfo
	on 
		id_regionName_info.categoryid=categoryNameInfo.id
	group by 
		id_regionName_info.dealgroupid,
		dealgroupshorttitle,
		dealgrouptitledesc,
		regionname


