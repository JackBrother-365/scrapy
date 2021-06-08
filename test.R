library(httr)
library(rvest)
library(readr)
library(dplyr)
library(tibble)
library(jiebaR)
library(ggplot2)
library(stringr)
library(tidytext)



# 讀入斷詞
engine <- worker(user ="./ntusd-full.txt")
# 將正負情緒詞語讀入
positive <- unique(read_csv("positive.txt"))
negative <- unique(read_csv("negative.txt"))
positive <- data.frame(word = positive, sentiments = 1)
negative <- data.frame(word = negative, sentiemtns = -1)
colnames(negative) = c("word","sentiment")
colnames(positive) = c("word","sentiment")
LIWC_ch <- rbind(positive, negative)



# 函數: kkbox 每 1~2 年的圖
draw <- function(path){

  songs <- read_csv(path)
  text <- vector()
  
  for (i in c(1:100)){
    print(i)
    html <- content(GET(songs$連結[i]))
    lyric <- html %>% html_nodes("p.lyrics") %>% html_text()
    test <- unlist(strsplit(lyric, "\n"))
    lyric <- test[!str_detect(test, "編曲|作詞|作曲")]
    lyric <- paste(lyric[lyric != ""], collapse = " ")
    text[i] <- lyric
  }

  for (i in c(1:100)){
    print(i)
    seg <- segment(text[i], engine)
    text[i] <- paste0(seg, collapse = "\u3000")
  }
  
  # 做成 dataframe
  docs_df <- tibble::tibble(
    rank = seq_along(songs$歌曲),
    content = text
  )
  
  tidy_text_format <- docs_df %>%
    unnest_tokens(output = "word", input = "content",
                  token = "regex", pattern = "\u3000")
  
  # 根據每首歌排名去分析正負向詞語
  emotion_dict <- tidy_text_format %>%
    inner_join(LIWC_ch, by = "word") %>%
    # group_by(rank) %>%
    summarize(sum = sum(sentiment))
  
  # 根據排名去畫圖
  ggplot(emotion_dict, aes(x = rank, y = sum)) +
    geom_col()

  return(emotion_dict)
}

song2021 <- draw("./song1.csv")
song2020 <- draw("./song2.csv")
song2019 <- draw("./song3.csv")
song2018 <- draw("./song4.csv")




