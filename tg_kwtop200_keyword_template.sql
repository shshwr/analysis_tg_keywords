use tuangou;


select 
	cityid,keyword
from 
	tuangou.tg_kwtop200_PV_info
where 
	dt='yyyy-mm-dd'
group by cityid,keyword
order by cityid

