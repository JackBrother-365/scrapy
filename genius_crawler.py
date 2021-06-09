import pandas as pd
from bs4 import BeautifulSoup
import time
import requests
import json
import re
import csv
import string
chart = pd.read_csv("/Users/spacegray0315/Desktop/R&Data_science/billboard/data/billboard/All.csv")
lyrics = []

for i in range(150:201):
    artist = chart["Artist"][i]
    song_title = chart["Song Title"][i]
    punct = string.punctuation
    for c in punct:
        artist = artist.replace(c, "")
        song_title = song_title.replace(c, "")
    artist_ = artist.split(" ")
    song_title_ = song_title.split(" ")
    link = "https://genius.com/"
    for j in range(len(artist_)):
        if j != 0:
            link = link + "-" + artist_[j]
        else:
            link = link + artist_[j]
    for k in range(len(song_title_)):
        link = link + "-" + song_title_[k]
    link += "-lyrics"
    print(link)
    r = requests.get(link)
    soup = BeautifulSoup(r.text,"html.parser")
    
    lyric = soup.find("p")
    if lyric is not None:
        lyric = lyric.text
        lyrics.append(lyric)
    else:
        lyric = ""
        lyrics.append(lyric)
    time.sleep(1)


fn2 = "alltest.csv"
with open(fn2, "w", encoding = "utf-8") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["Position", "Aritist", "Song title", "Lyrics"])
    
    for i in range(150:201):
        print(i)
        writer.writerow([i+1, chart["Artist"][i], chart["Song Title"][i], lyrics[i]])

