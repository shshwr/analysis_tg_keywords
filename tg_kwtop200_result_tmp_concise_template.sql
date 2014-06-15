use tuangou;
insert overwrite table tg_kwtop200_result_tmp_concise partition(dt='yyyy-mm-dd')
select 
	keyword,
	cityid,
	round(searchcount,0) as searchcount,
	round(resultcount,0) as resultcount,
	round(clickpercent,2),
	round(buyrate,2),
	dealgroupid,
	num,
	isSearch,
	list_info
from
	tuangou.tg_kwtop200_result_tmp result_tmp
where
	dt='yyyy-mm-dd'
order by cityid,searchcount desc,keyword,num desc;
