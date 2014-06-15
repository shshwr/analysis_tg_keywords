use tuangou;
insert overwrite table tg_kwtop200_result_tmp partition(dt='yyyy-mm-dd')
select 
	pv_deal_info.keyword,
	cityid,
	searchcount,
	resultcount,
	clickpercent,
	buyrate,
	pv_deal_info.dealgroupid,
	index_click,
	isSearch,
	num,
	dealgroupshorttitle,
	dealgrouptitledesc,
	regionname,
	categoryname,
	concat(pv_deal_info.dealgroupid,':',num,':',isSearch,':',dealgroupshorttitle,':',dealgrouptitledesc,':',regionname,':',categoryname) as list_info
from
(
	select
		keyword,
		cityid,
		searchcount,
		resultcount,
		clickpercent,
		buyrate,
		dealgroupid,
		index_click,
		isSearch,
		num
	from 
		tuangou.tg_kwtop200_PV_info
	where 
		dt='yyyy-mm-dd'
)pv_deal_info
left outer join
(
	select
		dealgroupid,dealgroupshorttitle,dealgrouptitledesc,regionname,categoryname
	from
		tg_kwtop200_dealgroup_region_category_info
	where 
		dt='yyyy-mm-dd'
)dealgroupInfo
on 
	pv_deal_info.dealgroupid=dealgroupInfo.dealgroupid
order by cityid,searchcount desc,num desc
