library(RMySQL)
library(dbConnect)
library(dplyr)
library(xts)

conn <- dbConnect(MySQL(), dbname="etc", username="etc_user", password="1qaz!QAZ", host="10.64.32.48")
dbSendQuery(conn,"SET NAMES utf8")
#cnt <- dbGetQuery(conn, "select count(*) from etc.M06A")
m06a_all <- dbGetQuery(conn, "select * from etc.M06A")
ds <- tbl_df(m06a_all)
class(ds)
dbDisconnect(conn)

etc_db <- src_mysql(dbname = "etc", host = "10.64.32.48", user = "etc_user", password = "1qaz!QAZ")
etc_tbl <- tbl(etc_db, "M06A")
glimpse(etc_tbl)

