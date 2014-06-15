#!/bin/sh
#cron:10 * * * *

. /etc/profile
. /data/rui.wang/analysis_tg_keywords/config.conf
cd $TG_CRON
sh getticket.sh.tuangoucron
cd $TG_TOP200_WORKDIR

log_error(){
	echo error: [`date +'%Y-%m-%d %H:%M:%S'`] $*
	
}

if [ $# -eq 1 ]; then
	STARTDATE=$1;
else
	STARTDATE=`date +%Y-%m-%d -d 'yesterday'`
fi

if [ ! -e $TG_DATA$STARTDATE  ]; then
	mkdir -p $TG_DATA$STARTDATE
fi


echo "try to get top 200 search words quality in date: " $STARTDATE
echo "begin to get top 200 search words quality info"

#获取keyword的pv记录
sed "s/yyyy-mm-dd/"${STARTDATE}"/g;"  tg_kwtop200_PV_info_template.sql> tg_kwtop200_PV_info.sql
hive -f  tg_kwtop200_PV_info.sql

RET="$?"
if [[ "$RET" -ne "0" ]]; then
	logger_error "获取keyword pv 记录失败"
	exit 1
fi

#获取dealgroup相关的regionid和regionName
sed "s/yyyy-mm-dd/"${STARTDATE}"/g;" tg_kwtop200_dealgroup_region_info_template.sql >tg_kwtop200_dealgroup_region_info.sql 
hive -f tg_kwtop200_dealgroup_region_info.sql

if [[ $? -ne 0 ]]; then
	logger_error "获取dealgroup相关的regionid和regionName失败"
	exit 1
fi

#获取categoryid and categoryname
sed "s/yyyy-mm-dd/"${STARTDATE}"/g;" tg_kwtop200_dealgroup_region_category_info_template.sql > tg_kwtop200_dealgroup_region_category_info.sql
hive -f tg_kwtop200_dealgroup_region_category_info.sql

if [[ $? -ne 0 ]]; then
        logger_error "获取categoryid and categoryname失败"
        exit 1
fi

#将pvInfo 和 上面两个求出来的regionname与categoryname join在一起
sed "s/yyyy-mm-dd/"${STARTDATE}"/g;" tg_kwtop200_result_tmp_template.sql > tg_kwtop200_result_tmp.sql
hive -f  tg_kwtop200_result_tmp.sql

if [[ $? -ne 0 ]]; then
        logger_error "pvInfo 和 上面两个求出来的regionname与categoryname join在一起失败"
        exit 1
fi

#对于细节的处理
sed "s/yyyy-mm-dd/"${STARTDATE}"/g;" tg_kwtop200_result_tmp_concise_template.sql > tg_kwtop200_result_tmp_concise.sql
hive -f tg_kwtop200_result_tmp_concise.sql 

if [[ $? -ne 0 ]]; then
        logger_error "于细节的处理失败"
        exit 1
fi

#加入购买的信息
sed "s/yyyy-mm-dd/"${STARTDATE}"/g;" tg_kwtop200_result_buy_info_template.sql > tg_kwtop200_result_buy_info.sql
hive -f  tg_kwtop200_result_buy_info.sql

if [[ $? -ne 0 ]]; then
        logger_error "加入购买的信息失败"
        exit 1
fi

#select top200 words into a top200_words.txt
sed "s/yyyy-mm-dd/"${STARTDATE}"/g;" tg_kwtop200_keyword_template.sql>tg_kwtop200_keyword.sql
hive -f tg_kwtop200_keyword.sql>top200_keywords.txt

if [[ $? -ne 0 ]]; then
        logger_error "select top200 words into a top200_words.txt失败"
        exit 1
fi

#add classification to the top200 keywords
python addCategorytoKW.py

if [[ $? -ne 0 ]]; then
        logger_error "add classification to the top200 keywords失败"
        exit 1
fi

#search the index with top200_keywords.txt
python GetSearchResult.py

if [[ $? -ne 0 ]]; then
        logger_error "search the index with top200_keywords.txt失败"
        exit 1
fi

#load index data into table:tg_kwtop200_index_info
hive -e "LOAD DATA LOCAL INPATH '/data/rui.wang/analysis_tg_keywords/SearchDealGroup.txt' INTO TABLE tuangou.tg_kwtop200_index_info partition(dt='$STARTDATE')"


if [[ $? -ne 0 ]]; then
        logger_error "load index data into table:tg_kwtop200_index_info失败"
        exit 1
fi


#select data into txt
sed "s/yyyy-mm-dd/"${STARTDATE}"/g;" tg_kwtop200_writetoTXT_template.sql>tg_kwtop200_writetoTXT.sql
hive -f  tg_kwtop200_writetoTXT.sql>${TG_DATA}kwTop200_report_result.txt


#计算nDCG指标
java -jar /data/rui.wang/jarsfolder/calcNDCG5.0.jar

#发邮件
java -jar /data/rui.wang/jarsfolder/nDCG_mail8.0.jar


