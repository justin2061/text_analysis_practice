#第i個變數的table
varName<-names(IV$Tables)[i]
n <-  varName%>% IV$Tables[[.]]%>%nrow()
head1<- paste(' <tr>
<td>
<table border="1"  height="150" width = "200" align="center">
<tr align="center">
<td><font face="微軟正黑體"><b>',names(IV$Tables)[i],'</b><font></td>
<td><font face="微軟正黑體"><b>WOE</b><font></td>
<td><font face="微軟正黑體"><b>IV</b><font></td>
</tr>',sep='')
tbj<-''
A<-IV$Tables[[varName]][[varName]]
woe<- IV$Tables[[varName]][["WOE"]]
iv<-IV$Tables[[varName]][["IV"]]
for(j in 1 :n){
tb<-paste('<tr align="center">
<td>',A[j],'</td>
<td>',round(woe[j],digits = 5 ),'</td>
<td>',round(iv[j],digits = 5 ),'</td>
</tr>\n',sep='')
tbj<-paste(tbj,tb)
}
content<-paste(head1,tbj,'</table> </td>')
img<- paste('<td> <img src = "',i,'.jpg"','></td>    </tr>',sep='')
fin<-paste(content,img)
html_table<-paste(html_table,fin)
}
html_table_E <-  '</table>
</body>
</html>'
html_fin<-paste(html_table_B,html_title,html_table,html_table_E,sep='')
#
ff <-file(paste(pic_output_path,'sample.html'), encoding="utf8")
cat(html_fin, append = F, file =ff)
####################################################################################################
#產圖
iv_plot <-'iv_plot.jpg'
jpeg(paste0(pic_output_path,iv_plot,sep=''))
#fills <- rev(brewer.pal(3, 'Blues'))
ggplot(data=iv_topvalue)+
geom_bar(aes(x=reorder(Variable,IV),y=IV), stat="identity") +
coord_flip() +
scale_fill_manual(values=fills) +
theme(
panel.grid.major.y = element_blank(),
panel.grid.major.x = element_line(linetype="dashed",colour="blue"),
panel.grid.minor = element_blank(),
panel.background = element_blank(),
axis.ticks.x = element_blank(),
axis.ticks.y = element_blank()
) +
xlab("Variable") +
ylab("Information Value") +
ggtitle("Information Value Summary")
dev.off()
#html 開始
html_table_B <-
'<html>
<head>
<meta http-equiv="Content-Type" content="charset=utf-8;text/html">
</head>
<body  bgcolor="#ffffff">
<table border="1"  align="center">'
#html title
html_title <-y %>%(function(y){
tmp1 <-'<tr>
<td colspan="3" align="center"><font size="6" face="微軟正黑體"><b>應變數 target: '
tmp2 <-y
tmp3 <- '</b></font></td>
</tr>'
return(paste(tmp1,tmp2,tmp3))
})
#html iv圖
html_plot <-iv_plot %>%(function(iv_plot){
tmp1 <-'<tr>
<td colspan="2" align="center"><img src = " '
tmp2 <-iv_plot
tmp3 <- '"></td>
</tr>'
return(paste(tmp1,tmp2,tmp3))
})
#html iv_table
head1<-'<tr align="center">
<td><font size="4" face="微軟正黑體"><b>順序</b></font></td>
<td><font size="4" face="微軟正黑體"><b>解釋變數中文</b></font></td>
<td><font size="4" face="微軟正黑體"><b>IV</b></font></td>
</tr>'
topn<-head(IV$Summary,topn_iv)
temp_1<-''
for (i in 1:topn_iv){
temp <-paste (' <tr align="center">',td(i),td(topn$Variable[i]),td(round(topn$IV[i],digits=5)),　'</tr>')
temp_1<-paste(temp_1,temp)
}
#html 結束
html_table_E <-  '</table>
</body>
</html>'
#產出html
html_fin<-paste(html_table_B,html_title,html_plot,temp_1,html_table_E,sep='')
ff <-file(paste(pic_output_path,'iv.html'), encoding="utf8")
cat(html_fin, append = F, file =ff)
##log
logfile<-'ok'
ff <-file(paste(pic_output_path,'1.log'), encoding="utf8")
cat(logfile, append = F, file =ff)
iv_topvalue
>
#參數設定
Sys.setlocale("LC_CTYPE", "zh_TW.UTF-8")
y <- "是否npout"
jobid <-'1'
topn_iv<-20
#infile <-
#outfil <-
#
tablenm <-'"prod".trainset_179'
pic_output_path <-'D:/tmp/test/'
library(data.table)
library(magrittr)
library(plyr)
library(dplyr)
library(Information)
library(magrittr)
library(ggplot2)
library(rJava)
library(RJDBC)
##RODBC
#dt <- sqlQuery(channel, paste("SELECT * FROM ",tablenm))%>% as.data.table()
#RJDBC
#install.packages("rJava",dep=TRUE)
#install.packages("RJDBC",dep=TRUE)
.jinit()
print(.jcall("java/lang/System", "S", "getProperty", "java.version"))
jdbcDriver <- JDBC(driverClass="com.asterdata.ncluster.Driver", classPath="D:/noarch-aster-jdbc-driver.jar")
jdbcConnection <- dbConnect(jdbcDriver, "jdbc:ncluster://10.68.64.112:2406/aaa", "aaa_prod", "aaapd135")
dt <- dbGetQuery(jdbcConnection, "SELECT * FROM prod.trainset_179 ") %>% as.data.table()
names(dt)<-iconv(names(dt),'utf8')
dbDisconnect(jdbcConnection)
#read.csv
#dt <- read.csv('training_179_2.csv') %>% as.data.table()
#write.table(dt,file ='D:/R/RHTML/RJPEG/table.csv',col.names = TRUE,row.names = FALSE,sep=",")
#dt2<- read.table('D:/R/RHTML/RJPEG/table.csv',header = TRUE,encoding="utf-8") %>% as.data.table()
# woeiv
dt[[y]]<-as.numeric(dt[[y]])
IV <- Information:::create_infotables(dt, y = y)
######## html 1#######################################################################################
#產出圖檔
names<-names(IV$Tables)
for (i in 1:length(names)){
jpeg(paste0(pic_output_path,i,'.jpg',sep=''))#,width =600, height=300,res=150
print(Information::plot_infotables(IV, names[i]))
dev.off()
}
#FUN
td =function(x){paste('<td>',x,'</td>\n')}
#html 開始
html_table_B <-'<html>
<head>
<meta http-equiv="Content-Type" content="charset=utf-8;text/html">
</head>
<body  bgcolor="#ffffff">
<table border="1"  align="center">'
#html title
html_title <-y %>%(function(y){
tmp1 <-'<tr>
<td colspan="2" align="center"><font size="6" face="微軟正黑體"><b>應變數 target: '
tmp2 <-y
tmp3 <- '</b></font></td>
</tr>'
return(paste(tmp1,tmp2,tmp3))
})
#html table
#length(IV$Tables
html_table<-''
for (i in 1:length(names)){
#第i個變數的table
varName<-names(IV$Tables)[i]
n <-  varName%>% IV$Tables[[.]]%>%nrow()
head1<- paste(' <tr>
<td>
<table border="1"  height="150" width = "200" align="center">
<tr align="center">
<td><font face="微軟正黑體"><b>',names(IV$Tables)[i],'</b><font></td>
<td><font face="微軟正黑體"><b>WOE</b><font></td>
<td><font face="微軟正黑體"><b>IV</b><font></td>
</tr>',sep='')
tbj<-''
A<-IV$Tables[[varName]][[varName]]
woe<- IV$Tables[[varName]][["WOE"]]
iv<-IV$Tables[[varName]][["IV"]]
for(j in 1 :n){
tb<-paste('<tr align="center">
<td>',A[j],'</td>
<td>',round(woe[j],digits = 5 ),'</td>
<td>',round(iv[j],digits = 5 ),'</td>
</tr>\n',sep='')
tbj<-paste(tbj,tb)
}
content<-paste(head1,tbj,'</table> </td>')
img<- paste('<td> <img src = "',i,'.jpg"','></td>    </tr>',sep='')
fin<-paste(content,img)
html_table<-paste(html_table,fin)
}
html_table_E <-  '</table>
</body>
</html>'
html_fin<-paste(html_table_B,html_title,html_table,html_table_E,sep='')
#
ff <-file(paste(pic_output_path,'sample.html'), encoding="utf8")
cat(html_fin, append = F, file =ff)
####################################################################################################
#產圖
iv_plot <-'iv_plot.jpg'
jpeg(paste0(pic_output_path,iv_plot,sep=''))
#fills <- rev(brewer.pal(3, 'Blues'))
ggplot(data=iv_topvalue)+
geom_bar(aes(x=reorder(Variable,IV),y=IV), stat="identity") +
coord_flip() +
scale_fill_manual(values=fills) +
theme(
panel.grid.major.y = element_blank(),
panel.grid.major.x = element_line(linetype="dashed",colour="blue"),
panel.grid.minor = element_blank(),
panel.background = element_blank(),
axis.ticks.x = element_blank(),
axis.ticks.y = element_blank()
) +
xlab("Variable") +
ylab("Information Value") +
ggtitle("Information Value Summary")
dev.off()
#html 開始
html_table_B <-
'<html>
<head>
<meta http-equiv="Content-Type" content="charset=utf-8;text/html">
</head>
<body  bgcolor="#ffffff">
<table border="1"  align="center">'
#html title
html_title <-y %>%(function(y){
tmp1 <-'<tr>
<td colspan="3" align="center"><font size="6" face="微軟正黑體"><b>應變數 target: '
tmp2 <-y
tmp3 <- '</b></font></td>
</tr>'
return(paste(tmp1,tmp2,tmp3))
})
#html iv圖
html_plot <-iv_plot %>%(function(iv_plot){
tmp1 <-'<tr>
<td colspan="2" align="center"><img src = " '
tmp2 <-iv_plot
tmp3 <- '"></td>
</tr>'
return(paste(tmp1,tmp2,tmp3))
})
#html iv_table
head1<-'<tr align="center">
<td><font size="4" face="微軟正黑體"><b>順序</b></font></td>
<td><font size="4" face="微軟正黑體"><b>解釋變數中文</b></font></td>
<td><font size="4" face="微軟正黑體"><b>IV</b></font></td>
</tr>'
topn<-head(IV$Summary,topn_iv)
temp_1<-''
for (i in 1:topn_iv){
temp <-paste (' <tr align="center">',td(i),td(topn$Variable[i]),td(round(topn$IV[i],digits=5)),　'</tr>')
temp_1<-paste(temp_1,temp)
}
#html 結束
html_table_E <-  '</table>
</body>
</html>'
#產出html
html_fin<-paste(html_table_B,html_title,html_plot,temp_1,html_table_E,sep='')
ff <-file(paste(pic_output_path,'iv.html'), encoding="utf8")
cat(html_fin, append = F, file =ff)
##log
logfile<-'ok'
ff <-file(paste(pic_output_path,'1.log'), encoding="utf8")
cat(logfile, append = F, file =ff)
rm()
names<-names(IV$Tables)
for (i in 1:length(names)){
png(paste0(pic_output_path,i,'.png',sep=''))#,width =600, height=300,res=150
print(Information::plot_infotables(IV, names[i]))
dev.off()
}
#FUN
td =function(x){paste('<td>',x,'</td>\n')}
#html 開始
html_table_B <-'<html>
<head>
<meta http-equiv="Content-Type" content="charset=utf-8;text/html">
</head>
<body  bgcolor="#ffffff">
<table border="1"  align="center">'
#html title
html_title <-y %>%(function(y){
tmp1 <-'<tr>
<td colspan="2" align="center"><font size="6" face="微軟正黑體"><b>應變數 target: '
tmp2 <-y
tmp3 <- '</b></font></td>
</tr>'
return(paste(tmp1,tmp2,tmp3))
})
#html table
#length(IV$Tables
html_table<-''
for (i in 1:length(names)){
#第i個變數的table
varName<-names(IV$Tables)[i]
n <-  varName%>% IV$Tables[[.]]%>%nrow()
head1<- paste(' <tr>
<td>
<table border="1"  height="150" width = "200" align="center">
<tr align="center">
<td><font face="微軟正黑體"><b>',names(IV$Tables)[i],'</b><font></td>
<td><font face="微軟正黑體"><b>WOE</b><font></td>
<td><font face="微軟正黑體"><b>IV</b><font></td>
</tr>',sep='')
tbj<-''
A<-IV$Tables[[varName]][[varName]]
woe<- IV$Tables[[varName]][["WOE"]]
iv<-IV$Tables[[varName]][["IV"]]
for(j in 1 :n){
tb<-paste('<tr align="center">
<td>',A[j],'</td>
<td>',round(woe[j],digits = 5 ),'</td>
<td>',round(iv[j],digits = 5 ),'</td>
</tr>\n',sep='')
tbj<-paste(tbj,tb)
}
content<-paste(head1,tbj,'</table> </td>')
img<- paste('<td> <img src = "',i,'.jpg"','></td>    </tr>',sep='')
fin<-paste(content,img)
html_table<-paste(html_table,fin)
}
html_table_E <-  '</table>
</body>
</html>'
html_fin<-paste(html_table_B,html_title,html_table,html_table_E,sep='')
#
ff <-file(paste(pic_output_path,'sample.html'), encoding="utf8")
cat(html_fin, append = F, file =ff)
####################################################################################################
#產圖
iv_plot <-'iv_plot.png'
iv_topvalue<-head(IV$Summary,topn_iv)
png(paste0(pic_output_path,iv_plot,sep=''))
#fills <- rev(brewer.pal(3, 'Blues'))
ggplot(data=iv_topvalue)+
geom_bar(aes(x=reorder(Variable,IV),y=IV), stat="identity") +
coord_flip() +
scale_fill_manual(values=fills) +
theme(
panel.grid.major.y = element_blank(),
panel.grid.major.x = element_line(linetype="dashed",colour="blue"),
panel.grid.minor = element_blank(),
panel.background = element_blank(),
axis.ticks.x = element_blank(),
axis.ticks.y = element_blank()
) +
xlab("Variable") +
ylab("Information Value") +
ggtitle("Information Value Summary")
dev.off()
#html 開始
html_table_B <-
'<html>
<head>
<meta http-equiv="Content-Type" content="charset=utf-8;text/html">
</head>
<body  bgcolor="#ffffff">
<table border="1"  align="center">'
#html title
html_title <-y %>%(function(y){
tmp1 <-'<tr>
<td colspan="3" align="center"><font size="6" face="微軟正黑體"><b>應變數 target: '
tmp2 <-y
tmp3 <- '</b></font></td>
</tr>'
return(paste(tmp1,tmp2,tmp3))
})
#html iv圖
html_plot <-iv_plot %>%(function(iv_plot){
tmp1 <-'<tr>
<td colspan="2" align="center"><img src = " '
tmp2 <-iv_plot
tmp3 <- '"></td>
</tr>'
return(paste(tmp1,tmp2,tmp3))
})
#html iv_table
head1<-'<tr align="center">
<td><font size="4" face="微軟正黑體"><b>順序</b></font></td>
<td><font size="4" face="微軟正黑體"><b>解釋變數中文</b></font></td>
<td><font size="4" face="微軟正黑體"><b>IV</b></font></td>
</tr>'
topn<-head(IV$Summary,topn_iv)
temp_1<-''
for (i in 1:topn_iv){
temp <-paste (' <tr align="center">',td(i),td(topn$Variable[i]),td(round(topn$IV[i],digits=5)),　'</tr>')
temp_1<-paste(temp_1,temp)
}
#html 結束
html_table_E <-  '</table>
</body>
</html>'
#產出html
html_fin<-paste(html_table_B,html_title,html_plot,temp_1,html_table_E,sep='')
ff <-file(paste(pic_output_path,'iv.html'), encoding="utf8")
cat(html_fin, append = F, file =ff)
##log
logfile<-'ok'
ff <-file(paste(pic_output_path,'1.log'), encoding="utf8")
cat(logfile, append = F, file =ff)
if( .Platform$OS.type != 'windows')
Sys.setlocale("LC_CTYPE", "zh_TW.UTF-8")
install.packages("rvest")
library("rvest")
lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")
print(rating)
rating
rating <- lego_movie %>%
html_nodes("strong span") %>%
html_text() %>%
as.numeric()
rating
source('~/.active-rstudio-document')
Sys.getlocale()
kages("astsa")
require(astsa)
install.packages("astsa")
require(astsa)
data(jj)
jj
ls()
jj[1]
jj[84]
jj[1:4]
jj[1:5]
length(jj)
jj[length(jj)]
? ls
data <- c(0.1, 0.2, 0.3, 0.4, 0.5)
library(RMySQL)
library(dbConnect)
library(dplyr)
library(xts)
etc_db <- src_mysql(dbname = "etc", host = "10.64.32.48", user = "etc_user", password = "1qaz!QAZ")
select(etc_tbl, DetectionTime_O, TripLength)
etc_tbl <- tbl(etc_db, "M06A")
select(etc_tbl, DetectionTime_O, TripLength)
select(etc_tbl, DetectionTime_O, TripLength, DetectionTime_D-DetectionTime_O)
select(etc_tbl, DetectionTime_O, TripLength) %>% mutate(tt = DetectionTime_D-DetectionTime_O)
select(etc_tbl, DetectionTime_O, DetectionTime_D, TripLength) %>% mutate(tt = DetectionTime_D-DetectionTime_O)
select(etc_tbl, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = (DetectionTime_D-DetectionTime_O)/60)
select(etc_tbl, DetectionTime_O, DetectionTime_D, TripLength) %>%
;
ss <- select(etc_tbl, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = (DetectionTime_D-DetectionTime_O)/3600, s = TripLength/tt)
head(ss)
ss <- select(etc_tbl, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = TripLength/(DetectionTime_D-DetectionTime_O)/3600)
head(ss)
ss <- select(etc_tbl, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = (DetectionTime_D-DetectionTime_O)/3600)
head(ss)
class(ss$DetectionTime_O)
ss <- select(etc_tbl, DetectionTime_O, DetectionTime_D, TripLength) %>%
top_n(500) %>%
collect()
ss <- etc_tbl %>% select(DetectionTime_O, DetectionTime_D, TripLength) %>%
filter(TripLength > 10)
head(ss)
ss <- etc_tbl %>%
top_n(500) %>%
select(DetectionTime_O, DetectionTime_D, TripLength) %>%
filter(TripLength > 10)
head(ss)
ss <- etc_tbl %>%
select(VehicleType, DetectionTime_O, DetectionTime_D, TripLength) %>%
group_by(VehicleType) %>%
collect()
ss
ss <- etc_tbl %>%
select(VehicleType, DetectionTime_O, DetectionTime_D, TripLength) %>%
collect()
rm(ss)
gc()
ss <- etc_tbl %>%
select(VehicleType, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = as.numeric( strptime(DetectionTime_O, "%Y-%m-%d %H:%M:%S")-strptime(DetectionTime_D, "%Y-%m-%d %H:%M:%S") ))
head(ss)
ss <- etc_tbl %>%
select(VehicleType, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = strptime(DetectionTime_O, "%Y-%m-%d %H:%M:%S")-strptime(DetectionTime_D, "%Y-%m-%d %H:%M:%S") )
head(ss)
ss <- etc_tbl %>% select(VehicleType, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = difftime(strptime(DetectionTime_O, "%Y-%m-%d %H:%M:%S")-strptime(DetectionTime_D, "%Y-%m-%d %H:%M:%S")) )
head(ss)
ss <- etc_tbl %>% select(VehicleType, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = DetectionTime_O-DetectionTime_D)
head(ss)
ss <- etc_tbl %>% select(VehicleType, DetectionTime_O, DetectionTime_D, TripLength) %>%
mutate(tt = (DetectionTime_D-DetectionTime_O)/60 )
head(ss)
gc()
savehistory("C:/Users/chiholee/Desktop/r-history-1.r")
