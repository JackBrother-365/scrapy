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
engine <- worker()
# 將正負情緒詞語讀入
English_dict <- get_sentiments("bing")

draw_english <- function(path){

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
    inner_join(English_dict, by = "word")

  return(emotion_dict)
}

song_en2021 <- draw_english("./english1.csv")
song_en2020 <- draw_english("./english2.csv")
song_en2019 <- draw_english("./english3.csv")
song_en2018 <- draw_english("./english4.csv")

song_en2019$sentiment[song_en2019$sentiment == "positive"] <- "en_positive"


