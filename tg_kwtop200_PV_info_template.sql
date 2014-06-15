use tuangou;                                                                                 
insert overwrite table tg_kwtop200_PV_info partition(dt='yyyy-mm-dd') 	
select 
		baseInfo.keyword,
		baseInfo.cityid,
		searchcount,
		resultcount,
		clickpercent,
		buyrate,
		dealgroupid,
		index_click,
		isSearch,
		num
	from	
		(	
			select 
				keyword,
				cityid,
				searchcount,
				resultcount,
				clickpercent,
				buyrate
			from
				(	
					select 
						keyword,
						cityid,
						searchcount,
						resultcount,
						clickpercent,
						buyrate
					from
						tuangou.tg_search_CTR_TR
					where
						dt='yyyy-mm-dd'  and regionid=0 and chanelid=0 and searchcount>=20
					order by cityid,searchcount desc
				)all_baseInfo
			where ROW_NUMBER(cityid)<=200
		)baseInfo
		left outer join
		(
			select 
				cityid,
				keyword,
				dealgroupid,
				round(avg(index_click),0) as index_click,
				isSearch,
				count(dealgroupid) as num
			from
				(
					select 
						cityid,keyword,dealgroupid,
						if(business_tags rlike 'index=',
						regexp_extract(business_tags,'(.*?)(index=)(\\d+)',3),0) as index_click,
						if(business_tags rlike '5_con_list',1,0) as isSearch
					from 
						tuangou.tg_search_mvlog_click_info 
					where 
						dt='yyyy-mm-dd'  and keyword is not null
				)info
			group by 
				cityid,keyword,dealgroupid,isSearch
			order by cityid,num desc
		)mvInfo
		on baseInfo.cityid=mvInfo.cityid and baseInfo.keyword=mvInfo.keyword


