library(httr)
library(rvest)
library(readr)
library(dplyr)
library(tibble)
library(jiebaR)
library(ggplot2)
library(stringr)
library(tidytext)

songs <- read_csv("./song.csv")

for (i in seq_along(songs$連結)){
  print(i)
  html <- content(GET(songs$連結[i]))
  lyric <- html %>% html_nodes("p.lyrics") %>% html_text()
  test <- unlist(strsplit(lyric, "\n"))
  lyric <- list(test[!str_detect(test, "編曲|作詞|作曲")])
  lyric <- list(lyric[[1]][lyric[[1]] != ""])
  segged <- unique(segment(lyric[[1]], worker()))
  songs$歌詞[i] <- paste0(segged, collapse = "\u3000")
  Sys.sleep(1)
}

# 做成 dataframe
docs_df <- tibble::tibble(
  rank = seq_along(songs$歌曲),
  content = docs_segged
)
write.table(docs_df, "song.txt")

tidy_text_format <- docs_df %>%
  unnest_tokens(output = "word", input = "content",
                token = "regex", pattern = "\u3000")

# # 將正負情緒詞語讀入
# positive <- unique(read_csv("positive.txt"))
# negative <- unique(read_csv("negative.txt"))
# positive <- data.frame(word = positive, sentiments = 1)
# negative <- data.frame(word = negative, sentiemtns = -1)
# colnames(negative) = c("word","sentiment")
# colnames(positive) = c("word","sentiment")
# LIWC_ch <- rbind(positive, negative)
# 
# # 根據每首歌排名去分析正負向詞語
# emotion_dict <- tidy_text_format %>%
#   inner_join(LIWC_ch, by = "word") %>%
#   # group_by(rank) %>%
#   summarize(sum = sum(sentiment))
# 
# 
# 
# ggplot(emotion_dict, aes(x = rank, y = sum)) +
#   geom_col()
