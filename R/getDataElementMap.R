#' @title getDataElementMap(base.url,username,passowrd)
#' 
#' @description Utility function of extraction of data element ids, codes, shortName and names
#'
#' @param base.url Location of the server
#' @param username Server username
#' @param password Server password
#' @return Returns a data frame  of id,code,shortName and name
#' 

getDataElementMap<-function(base.url,username,password) {
  url<-URLencode(paste0(base.url,"api/dataElements?fields=id,code,shortName,name,numberType,optionSet[id]&paging=false"))
  sig<-digest::digest(url,algo='md5', serialize = FALSE)
  des<-getCachedObject(sig)
  if (is.null(des)){
  r<-httr::GET(url, httr::authenticate(username,password),httr::timeout(60))
  if (r$status == 200L ){
    r<- httr::content(r, "text")
    des<-jsonlite::fromJSON(r,flatten=TRUE)[[1]]
    saveCachedObject(des,sig)
     } else {
      print(paste("Could not retreive data elements",httr::content(r,"text")))
      des<-NULL
    } 
  }
  return( des )
}