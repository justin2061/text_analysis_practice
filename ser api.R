library("httr")


get_api_token <- function(){
  api_token_url <- "https://api.ser.ideas.iii.org.tw:443/api/user/get_token"
  body <- list(id = "d0f56b053cc318b0c31463d2d5ce8a2d", secret_key = '7074182df4e3ed18caff778a5c583543')
  api_token <- POST(api_token_url, body = body)
  stop_for_status(api_token)
  response <- content(api_token)
  if(response$message == "success")
    api_token <- response$result$token
  return(api_token)  
}

tv_chwatch_url <- 'http://54.92.30.60:80/api/tv/chwatch'
tv_chwatch_body <- list(st = "20150501", et = "20150507", i = "1", t = "1", d="1", token = get_api_token())
tv_chwatch_resp <- POST(tv_chwatch_url, body = tv_chwatch_body)
resp <- content(tv_chwatch_resp)