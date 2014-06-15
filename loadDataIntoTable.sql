LOAD DATA LOCAL INPATH '/data/rui.wang/analysis_tg_keywords/SearchDealGroup.txt' INTO TABLE tuangou.tg_kwtop200_index_info partition(dt='$STARTDATE')
