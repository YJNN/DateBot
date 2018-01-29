library(tm)
library(KoNLP)
library(stringr)

ko.words=function(doc){
  d=as.character(doc)
  extractNoun(d)
}
#CPU 코어를 하나만 사용, 텍스트 분석 충돌 방지
options(mc.score=1)

metro = read.csv("강남역.csv", stringsAsFactors = F)

cps <- Corpus(VectorSource(metro$titlesum))  

#영어 기준을 한글 기준으로 바꿔준다.
tdm <- TermDocumentMatrix(cps,
                          control=list(tokenize=ko.words, #문장 분리 기준으로 미리 만든 함수 이용
                                       removePunctuation=T, #문장 기호 제거
                                       removeNumbers=T, #숫자 제거
                                       wordLengths=c(2, 5), #단어 선택 기준 2~5글자 사이
                                       weighting=weightBin)) # 횟수가 아닌 빈도수로 변경 

tdm.matrix=as.matrix(tdm)

word.count <- rowSums(tdm.matrix)

word.order <- order(word.count, decreasing=T)
freq.words <- tdm.matrix[word.order[1:20], ]

freq.words %*% t(freq.words) 
co.matrix=freq.words %*% t(freq.words)

write.csv(co.matrix,"강남역 단어.csv")
