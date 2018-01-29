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

#TDM을 매트릭스로 변경
tdm.matrix=as.matrix(tdm)

word.count <- rowSums(tdm.matrix)

#횟수에 따라 내림차순으로 정렬
word.order <- order(word.count, decreasing=T)

#Term document Matrix에서 자주 쓰인 단어 상위 20개에 해당하는 것만 추림
freq.words <- tdm.matrix[word.order[1:20], ]

#행렬의 곱셈을 이용해 TERM Matrix를 co-occurence Matrix로 바꿈
freq.words %*% t(freq.words) 

co.matrix=freq.words %*% t(freq.words)

#파일로 출력 
write.csv(co.matrix,"강남역 단어.csv")
