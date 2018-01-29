library(httr)
library(rvest)
library(selectr)

#함수를 이용해 블로그 크롤링 
daum <- function(number){
  url=paste('http://search.daum.net/search?w=blog&nil_search=btn&DA=PGD&enc=utf8&q=%EB%8C%80%EB%A6%BC%EC%97%AD&page=',number,'&m=board',sep="")
  
  response=GET(url)
  htxt <- html(response)
  
  main<- html_nodes(htxt, 'div.coll_cont.coll_tab')
  title<-  html_nodes(main, 'a.f_link_bu')
  
  title<-html_text(title)
  titlesum = ""
  
  #리스트 형식의 기사내용을 하나의 문자열로 만듦
  for(i in 1: length(title)){
    titlesum = paste(titlesum,title[i],sep="\n")
  }
  
  #문자열 다듬기
  titlesum <- gsub("\n|\t|\r","",titlesum)
  titlesum <- gsub(" ","",titlesum)
  
  return(titlesum)
}

dataSet = data.frame(stringsAsFactors=FALSE)

#총 89페이지에 대해서 블로그 타이틀을 긁어온뒤 하나의 데이터 프레임으로 합친다. 
for(i in 1 : 89){
  dataSet = rbind(dataSet, daum(i))
}

#데이터 저장 
write.table(dataSet,"강남역.csv",sep=",",row.names=FALSE, fileEncoding="CP949")