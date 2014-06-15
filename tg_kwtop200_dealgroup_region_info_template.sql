use tuangou;
insert overwrite table tg_kwtop200_dealgroup_region_info partition(dt='yyyy-mm-dd') 
select 
	idInfo.dealgroupid,
	dealgroupshorttitle,
	dealgrouptitledesc,
	concat_ws('|',collect_set(regionNameInfo.regionname)) as region
from 
(
	
select
	dpInfo.dealgroupid,dealgroupshorttitle,dealgrouptitledesc,shopinfo,regionid
from
	(
		select 
			b.dealgroupid,dealgroupshorttitle,dealgrouptitledesc,shopinfo,pvInfo.dealgroupid as alias
		from
			(
				select
					dealgroupid,dealgroupshorttitle,dealgrouptitledesc,shopinfo
				from 
					bi.dpods_tg_dealgroup 
				where 
					hp_statdate='yyyy-mm-dd' and enddate>'yyyy-mm-dd'
				
			)b
			left outer join
			(
				select dealgroupid 
				from tuangou.tg_kwtop200_PV_info
				where dt='yyyy-mm-dd' and isSearch=1
			)pvInfo
			on b.dealgroupid=pvInfo.dealgroupid
		where 
			pvInfo.dealgroupid is not null				
	)dpInfo
	left outer join
	(
		select 
				dealgroupid,regionid
			from
				bi.dpods_tg_dealregion 
			where 
				hp_statdate='yyyy-mm-dd'
	)r
	on dpInfo.dealgroupid=r.dealgroupid
)idInfo
left outer join
(
	select 
		regionid,regionname
	from
		bi.dpods_dp_regionlist 
	where 
		hp_statdate='yyyy-mm-dd'
)regionNameInfo
on idInfo.regionid=regionNameInfo.regionid
group by 
	idInfo.dealgroupid,
	dealgroupshorttitle,
	dealgrouptitledesc

