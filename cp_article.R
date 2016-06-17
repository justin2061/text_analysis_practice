library(RMySQL)
library(dbConnect)
library(dplyr)

#-- 方法一
conn <- dbConnect(MySQL(), dbname="lucy", username="lucy_db", password="zaxscdvf", host="127.0.0.1")
dbSendQuery(conn,"SET NAMES utf8")
#cnt <- dbGetQuery(conn, "select count(*) from etc.M06A")
all_article <- dbGetQuery(conn, "select * from lucy.article")
ds <- tbl_df(all_article)
class(ds)
dbDisconnect(conn)

#-- 方法二
article_db <- src_mysql(dbname = "lucy", host = "127.0.0.1", user = "lucy_db", password = "zaxscdvf")
article_tbl <- tbl(article_db, "article")
glimpse(article_tbl)