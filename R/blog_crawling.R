library(httr)
library(rvest)
library(selectr)

daum <- function(number){
  url=paste('http://search.daum.net/search?w=blog&nil_search=btn&DA=PGD&enc=utf8&q=%EB%8C%80%EB%A6%BC%EC%97%AD&page=',number,'&m=board',sep="")
  
  response=GET(url)
  htxt <- html(response)
  
  main<- html_nodes(htxt, 'div.coll_cont.coll_tab')
  title<-  html_nodes(main, 'a.f_link_bu')
  
  title<-html_text(title)
  titlesum = ""
  
  for(i in 1: length(title)){
    titlesum = paste(titlesum,title[i],sep="\n")
  }
  
  titlesum <- gsub("\n|\t|\r","",titlesum)
  titlesum <- gsub(" ","",titlesum)
  
  return(titlesum)
}

dataSet = data.frame(stringsAsFactors=FALSE)

for(i in 1 : 89){
  dataSet = rbind(dataSet, daum(i))
}

write.table(dataSet,"강남역.csv",sep=",",row.names=FALSE, fileEncoding="CP949")
