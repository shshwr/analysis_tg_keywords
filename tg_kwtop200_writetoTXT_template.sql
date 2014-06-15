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
	classification,
	cityname,
	cityenname
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
			kw_info.cityid,
			cityname,
			cityenname,
			keyword,
			classification,
			index_search,
			dealgroupid
		from
			(
				select 
					cityid,keyword,classification,index_search,dealgroupid
				from
					tuangou.tg_kwtop200_index_info
				where 
					dt='yyyy-mm-dd' 
			)kw_info
			join
			(
				select 
					top20city_info.cityid,cityName_info.cityname,cityenname
				from
				(
					select cityid,sum(searchcount) as searchcount
					from tuangou.tg_search_CTR_TR_weekly
					where dt='yyyy-mm-dd'
					group by cityid
					order by searchcount desc
					limit 20		
				)top20city_info
				join
				(
					select * from tuangou.tg_search_wr_city_info where cityid<400
				)cityName_info
				on 
					cityName_info.cityid=top20city_info.cityid
			)city_info
			on kw_info.cityid=city_info.cityid
	)indexinfo
	on 
		baseinfo.cityid=indexinfo.cityid
		and baseinfo.keyword=indexinfo.keyword
		and baseinfo.dealgroupid=indexinfo.dealgroupid
order by 
	cityid,searchcount desc,keyword,num desc,index_search

