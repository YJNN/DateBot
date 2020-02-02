library(httr)
library(rvest)
library(XML)

movie=read.csv("aa.csv",stringsAsFactors = F)
title=movie$title
head(title)
for(i in 1:6095)
{
  title[i]=gsub(" ","",title[i])
}
movie$title=title

result=data.frame(stringsAsFactors = F)
result=c('장르')

for( t in title){
  url=paste("http://movie.daum.net/search.do?type=movie&q=",t,sep = "")
  htxt=html(url)
  a=(html_nodes(htxt,'dl.fst.clearfix'))
  b=html_nodes(a,'span.item')
  output=html_text(b)[1]
  
  if(length(html_text(c))==0){
    result=rbind(result,NA)
  } else{
    result=rbind(result,output)
  } 
}

View(result)
write.csv(result,"genre.csv")
