use tuangou;
select 
	baseinfo.keyword,
	baseinfo.cityid,
	searchcount, 
	resultcount,
	clickPercent ,
	buyrate ,
	baseinfo.dealgroupid ,
	indexinfo.index_search ,
	num ,
	buy_num ,
	dealgroupshorttitle ,
	dealgrouptitledesc ,
	regionname ,
	categoryname,
	classification
from
	(
		select 
			keyword,
			cityid,
			searchcount, 
			resultcount,
			clickPercent ,
			buyrate ,
			dealgroupid ,
			index_click ,
			num ,
			buy_num ,
			dealgroupshorttitle ,
			dealgrouptitledesc ,
			regionname ,
			categoryname
		from tg_kwtop200_result_buy_info
		where dt='yyyy-mm-dd'
	)baseinfo
	inner join
	(
		select 
			cityid,keyword,classification,index_search,dealgroupid
		from
			tuangou.tg_kwtop200_index_info
		where 
			dt='yyyy-mm-dd'and 
			cityid in (1,2,4,7,10,5,8,3,6,16,17,9,18,160,21,13,22,19,110,79)
	)indexinfo
	on 
		baseinfo.cityid=indexinfo.cityid
		and baseinfo.keyword=indexinfo.keyword
		and baseinfo.dealgroupid=indexinfo.dealgroupid
order by 
	cityid,searchcount desc,keyword,num desc,index_search
