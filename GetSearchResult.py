__author__ = 'rui.wang'
# encoding=utf-8

import sys
import re
import codecs
import simplejson as json
import urllib2
import time

#input file
top200QueryFile = open("/data/rui.wang/analysis_tg_keywords/top200_kw_cate.txt", "r")

#output file
searchDealGroupFile = open("/data/rui.wang/analysis_tg_keywords/SearchDealGroup.txt", "w")

keywordDict = {}
#define url pattern
#urlPattern = "http://10.1.11.8:4123/search/tuangou?query=term(cityid,_CITYID_,-1),ge(endtimestamp,1397532566),keyword(searchkeyword,_KEYWORD_),lt(begintimestamp,1397532566)&sort=asc(dealstatus),asc(taga)&limit=0,96&fl=dealgroupid,dealgroupshorttitle&info=app:AppName.TG,platform:WWW,userIP:180.166.152.82,queryid:cd40580f-2171-49ad-b0bf-80e7c6aadce2,clientip:10.1.4.121,rankcity:_CITYID_,userId:0,tagcity:taga2city,cookieId:2f99265f-2292-4884-b7be-0e837625a400,retrytimes:1,tagscore:taga2score,tagrank:taga2rank"

urlPattern = "http://10.1.11.8:4123/search/tuangou?query=term(cityid,_CITYID_,-1),keyword(searchkeyword,_KEYWORD_)&filter=range(enddate,_NOWTIME_,null,true,false),range(begindate,null,_NOWTIME_,true,false)&sort=asc(defaultsort)&limit=0,96&fl=dealgroupid,dealstatus&info=referguid:0a010235-146387a5ae5-9318,geotype:shoppos,app:AppName.TG,platform:WWW,userIP:180.166.152.90,queryid:c1cf605e-1eba-4d6d-8626-1e85e16a8d34,clientip:10.1.111.178,functiontype:0,shoplocatecity:_CITYID_,searchcity:_CITYID_,cookieId:2f99265f-2292-4884-b7be-0e837625a400,lng:0.0,retrytimes:1,tagscore:taga2score,tagrank:taga2rank,locateaccuracy:0,rankcity:_CITYID_,userId:0,tagcity:taga2city,requesttype:0,lat:0.0"

nowtime=time.strftime('%Y%m%d%H%M%S',time.localtime(time.time()))
urlPattern=re.sub("_NOWTIME_",nowtime,urlPattern)
for line in top200QueryFile:
	lineTmp = line.strip("\n")
	cityid=lineTmp.split("\t")[0]
	keyword=lineTmp.split("\t")[1]
	classification=lineTmp.split("\t")[2]
	url = re.sub("_KEYWORD_", urllib2.quote(keyword), urlPattern)
	url = re.sub("_CITYID_", urllib2.quote(cityid), url)
	print keyword
	searchDealListJson = urllib2.urlopen(url).read()
	#print searchDealListJson
	searchDealList = json.loads(searchDealListJson)
	searchIndex = 0
	for obj in searchDealList['records']:
		searchIndex += 1
        	searchDealGroupFile.write(cityid+"\t"+keyword + "\t" + classification + "\t" +obj['dealgroupid'] + "\t" + str(searchIndex) + "\n")
