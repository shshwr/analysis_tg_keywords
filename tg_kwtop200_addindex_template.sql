use tuangou;
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
where dt='2014-04-21'
order by cityid,searchcount desc,keyword,num desc,index_click
