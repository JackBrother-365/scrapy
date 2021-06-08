library(tidyverse)
library(tibble)

data <- read.csv("/Users/spacegray0315/Desktop/R&Data_science/R_test/song_test.csv")
head(data)
library(jiebaR)

engine_s <- worker(user ="./ntusd-full.txt")
content <- vector()
for (i in data$歌詞){
  seg <- segment(i, engine_s)
  content <- c(content, seg)
}
head(content)

f <- freq(content)
f <- f[order(f[2], decreasing = TRUE),]
head(f, 100)

library('devtools') 
library(wordcloud2)
f2 <- f[1:150,]
wordcloud2(f2, size = 0.8, shape = "diamond")
