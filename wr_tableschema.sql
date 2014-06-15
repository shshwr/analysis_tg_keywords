use tuangou;
drop table if exists tg_kwtop200_anysis_tmp;
create table if not exists tg_kwtop200_anysis_tmp
(
        Keyword STRING,
        CityID INT,
        searchcount int,
        resultcount int,
        ClickPercent Double,
	buyrate Double,
	dealgroupid String,
	dealgroupshorttitle String,
	dealgrouptitledesc string,
	shopinfo string,
	regionname string,
	categoryname string

)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_anysis_tmp';


use tuangou;
drop table if exists tg_kwtop200_dealgroup_info;
create table if not exists tg_kwtop200_dealgroup_info
(
	dealgroupid String,
	dealgroupshorttitle String,
	dealgrouptitledesc string,
	shopinfo string,
	regionname string,
	categoryname string

)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_dealgroup_info';


use tuangou;
drop table if exists tg_kwtop200_PV_info;
create table if not exists tg_kwtop200_PV_info
(
        Keyword STRING,
        CityID INT,
        searchcount int,
        resultcount int,
        ClickPercent Double,
	buyrate Double,
	dealgroupid String,
	index_click int,
	isSearch int,
	num int
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_PV_info';


use tuangou;
drop table if exists tg_kwtop200_result;
create table if not exists tg_kwtop200_result
(
        Keyword STRING,
        CityID INT,
        SearchCount int,
        ResultCount int,
        ClickPercent Double,
	buyrate Double,
	listinfo_group string
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_result';


use tuangou;
drop table if exists tg_kwtop200_result_tmp;
create table if not exists tg_kwtop200_result_tmp
(
        Keyword STRING,
        CityID INT,
        searchcount int,
        resultcount int,
        ClickPercent Double,
	buyrate Double,
	dealgroupid STRING,
	index_click int,
	isSearch int,
	num int,
	dealgroupshorttitle STRING,
	dealgrouptitledesc STRING,
	regionname STRING,
	categoryname STRING,
	list_info STRING
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_result_tmp';


use tuangou;
drop table if exists tg_kwtop200_dealgroup_region_info;
create table if not exists tg_kwtop200_dealgroup_region_info
(
	dealgroupid STRING,
	dealgroupshorttitle STRING,
	dealgrouptitledesc STRING,
	regionname STRING
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_dealgroup_region_info';

use tuangou;
drop table if exists tg_kwtop200_dealgroup_region_category_info;
create table if not exists tg_kwtop200_dealgroup_region_category_info
(
	dealgroupid STRING,
	dealgroupshorttitle STRING,
	dealgrouptitledesc STRING,
	regionname STRING,
	categoryname string
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_dealgroup_region_category_info';

use tuangou;
drop table if exists tg_kwtop200_result_tmp_concise;
create table if not exists tg_kwtop200_result_tmp_concise
(
        Keyword STRING,
        CityID INT,
        SearchCount int,
        ResultCount int,
        ClickPercent Double,
	buyrate Double,
	dealgroupid STRING,
	num int,
	isSearch int,
	list_info STRING
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_result_tmp_concise';

use tuangou;
drop table if exists tg_kwtop200_result_buy_info;
create table if not exists tg_kwtop200_result_buy_info
(
        Keyword STRING,
        CityID INT,
        searchcount int,
        resultcount int,
        ClickPercent Double,
	buyrate Double,
	dealgroupid STRING,
	index_click int,
	isSearch int,
	num int,
	buy_num int,
	dealgroupshorttitle STRING,
	dealgrouptitledesc STRING,
	regionname STRING,
	categoryname STRING,
	list_info STRING
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_result_buy_info';

use tuangou;
CREATE TABLE IF NOT EXISTS tg_kwtop200_index_info
(
        cityid int,
	keyword String,
	classification string,
        dealgroupid int,
        index_search int
)
partitioned by (dt String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/tg_kwtop200_index_info';


use tuangou;
create table mobile_top200kw_info_temp
(
	keyword string,
	cityid int,
	dealgroupid string,
	clicknum int,
	searchcount int,
	clickpercent double,
	buyrate double
)
partitioned by (dt string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/tuangoucron/mobile_top200kw_info_temp';
