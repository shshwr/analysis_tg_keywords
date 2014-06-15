__author__ = 'wenshi.chen'
# encoding=utf-8

import sys
import pdb
reload(sys)
sys.setdefaultencoding("utf-8")
sys.path.append("../")
import jieba
import re


#input file
categoryFile=open("categoryFile.txt","r")
regionFile=open("regionFile.txt","r")
brandFile=open("brandFile.txt","r")
keywordsFile=open("top200_keywords.txt","r")

#output file
writeFile=open("top200_kw_cate.txt","w")

#define normal dict
categoryDict=[]
regionDict=[]
brandDict=[]
keywordDict=[]
outputDict=[]

#标志是否分类成功
isClass=0

#load categoryName into category dictionary
for line in categoryFile:
	line=line.strip().lower()
	lineArray=line.split("\t")
	if(len(lineArray)<2):
		continue;
	categoryId=lineArray[0]
	#
	categoryName=lineArray[1].strip()
	categoryDict.append(categoryName)


#load regionName into region dict
for line in regionFile:
	line=line.strip().lower()
	lineArray=line.split("\t")
	if(len(lineArray)<2):
		continue;
	regionId=lineArray[0]
	regionName=lineArray[1]
	regionDict.append(regionName)

#load brand name into brand dict
for line in brandFile:
	line=line.strip().lower()
	lineArray=line.split("\t")
	if(len(lineArray)<2):
		continue;
	brandId=lineArray[0]
	brandName=lineArray[1]
	brandDict.append(brandName)

#load keywords into keyword dict
for line in keywordsFile:
	line=line.strip().lower()
	lineArray=line.split("\t")
	if(len(lineArray)<2):
		continue;
	cityid=lineArray[0]
	keyword=lineArray[1]
	lineArray.append('')#left a seat for classification
	keywordDict.append(lineArray)

#add class for all the keyword
for kwArray in keywordDict:
	keyword=kwArray[1]
        keyword = re.sub("\(.*?\)|、|\\|/|\"", "", keyword)                                                                                                                             
        keyword = re.sub("（.*?）", "", keyword)                                                                                                                                        
        keyword = re.sub("【.*?】", "", keyword)                                                                                                                                        
        keyword = re.sub("[.*?]", "", keyword)                                                                                                                                          
        keyword = re.sub("�", "", keyword)                                                                                                                                              
        keyword = re.sub("\'", "", keyword)                                                                                                                                             
	
	isClass=0
	#pdb.set_trace()
	if (keyword in categoryDict):
		kwArray[2]='标准分类'
	elif (keyword in regionDict):
		kwArray[2]='地标'
	elif (keyword in brandDict):
		kwArray[2]='品牌名称'
	#如果输入的不是标准词汇，再去检查内部的缩写：例如日月光，环球港，七天等
	else: 
		
		'''for region in regionDict:
			if (keyword in region):
				kwArray[2]='地标'
				print('加载地标成功'+kwArray[2])
				isClass=1
				print('isClass'+str(isClass))
				break
		if(isClass==0):'''
		kwArray[2]='其他分类'
	
	writeFile.write(kwArray[0]+"\t"+kwArray[1]+"\t"+kwArray[2]+"\n")
	writeFile.flush()

#closeFile
categoryFile.close()
regionFile.close()
brandFile.close()
keywordsFile.close()

print " End !"


	



