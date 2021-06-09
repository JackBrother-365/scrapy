import pandas as pd
from bs4 import BeautifulSoup
import time
import requests
import json
import re
import csv
import string
chart = pd.read_csv("/Users/spacegray0315/Desktop/R&Data_science/billboard/All.csv")
lyrics = []
for i in range(150,201):
    Artist = chart["Artist"][i]
    Title = chart["Title"][i]
    punct = string.punctuation
    for c in punct:
        artist = Artist.replace(c, "")
        title = Title.replace(c, "")
    artist_ = Artist.split(" ")
    title_ = Title.split(" ")
    link = "https://www.musixmatch.com/lyrics/"
    for j in range(len(artist_)):
        if j != 0:
            link = link + "-" + artist_[j]
        else:
            link = link + artist_[j]
    link += "/"
    for k in range(len(title_)):
        if k != 0:
            link = link + "-" + title_[k]
        else:
            link = link + title_[k]
    print(link)
    r = requests.get(link)
    soup = BeautifulSoup(r.text,"html.parser")
    
    lyric = soup.find_all("span", class_="lyrics__content__ok")
    if lyric is not None:
        lyric = lyric.text
        lyrics.append(lyric)
    else:
        lyric = ""
        lyrics.append(lyric)
    time.sleep(1)


fn2 = "test.csv"
with open(fn2, "w", encoding = "utf-8") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["Position", "Aritist", "Song title", "Lyrics"])
    
    for i in range(150, 201):
        print(i)
        writer.writerow([i+1, chart["Artist"][i], chart["Title"][i], lyrics[i]])

