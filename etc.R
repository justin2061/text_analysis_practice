library("httr")
library("downloader")
# http://tisvcloud.freeway.gov.tw/history/TDCS/M06A/20160228/23/TDCS_M06A_20160228_230000.csv

work_dir <- "d:/etc"
data_dir <- paste(work_dir, "/data", sep = "")
csv_dir <- paste(work_dir, "/all_csv", sep = "")
if(!dir.exists(data_dir))
  dir.create(data_dir, recursive = TRUE)
if(!dir.exists(csv_dir))
  dir.create(csv_dir, recursive = TRUE)

# ymd <- format(Sys.time(), "%Y%m%d")
# hh <- format(Sys.time(), "%H")
# file_name <- format(Sys.time(), "TDCS_M06A_%Y%m%d_%H0000")
# url_pattern <- "http://tisvcloud.freeway.gov.tw/history/TDCS/M06A/%s/%s/%s"
# url <- sprintf(url_pattern, ymd, hh, file_name)


fetch_history_gz <- function(){
  s <- as.Date("2014-01-01")
  e <- as.Date("2016-02-27")
  ss <- seq(from=s, to=e, by=1)
  ss_string <- lapply(ss, identity)
  
  for(day in ss_string){
    m06a_url <- format(as.Date(day), "http://tisvcloud.freeway.gov.tw/history/TDCS/M06A/M06A_%Y%m%d.tar.gz")
    dest_filename <- format(as.Date(day), "./M06A_%Y%m%d.tar.gz")
    dest_file <- paste(data_dir, dest_filename, sep = "")
    print(m06a_url)
    #' check m06a file exist on local
    if(!file.exists(dest_file)){
      #' check m06a file exist on remote, download it.
      res = GET(url = m06a_url)
      if(res$status_code == 200){
        download.file(url = m06a_url, destfile = dest_file, quiet = TRUE)
        #untar(dest_file, exdir = data_dir)  
      }
    }
  }
  
  #untar
  all_gz <- list.files(path = data_dir, recursive = TRUE, pattern = "*\\.tar\\.gz$", include.dirs = TRUE, full.names = FALSE)
  for(gz in all_gz){
    gz_file <- paste(data_dir, gz, sep = "/")
    print(gz_file)
    untar(gz_file, exdir = data_dir)
    #copy csv file --> read csv write to db
    all_csv <- list.files(path = data_dir, recursive = TRUE, pattern = "*\\.csv$", include.dirs = TRUE, full.names = FALSE)
    #all_csv_filename = basename(all_csv)
    for(f in all_csv){
      cp_from <- paste(data_dir, f, sep = "/")
      print(cp_from)
      file.copy(from = cp_from, to = csv_dir, overwrite = TRUE, recursive = TRUE)
      #TODO write to db
      file.remove(cp_from)
    }
  }
}

fetch_history_gz()

fetch_etc_data <- function(){
  
}
