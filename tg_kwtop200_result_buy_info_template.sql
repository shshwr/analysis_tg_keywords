use tuangou;
insert overwrite table tg_kwtop200_result_buy_info partition(dt='yyyy-mm-dd')
select 
	click_info.keyword,
	click_info.cityid,
	round(searchcount,0) as searchcount,
	round(resultcount,0) as resultcount,
	round(clickpercent,2) as clickpercent,
	round(buyrate,2) as buyrate,
	click_info.dealgroupid,
	index_click,
	isSearch,
	num,
	if(sum_deal is null,0,sum_deal) as buy_num,
	dealgroupshorttitle,
	dealgrouptitledesc,
	regionname,
	categoryname,
	list_info
	
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
        num,
        dealgroupshorttitle,
        dealgrouptitledesc,
        regionname,
        categoryname,
		list_info
	from 
		tuangou.tg_kwtop200_result_tmp
	where 
		dt='yyyy-mm-dd' and isSearch=1
)click_info
left outer join
(
	select 
		cityid,
		keyword,
		dealgroupid,
		count(dealgroupid) as sum_deal
	from 
		tuangou.tg_search_order_src_info
	where 
		dt='yyyy-mm-dd'
	group by cityid,keyword,dealgroupid
	order by cityid,sum_deal desc
)buy_info
on 
	click_info.cityid=buy_info.cityid
	and click_info.keyword=buy_info.keyword
	and click_info.dealgroupid=buy_info.dealgroupid
order by cityid,searchcount desc,keyword,num desc;
