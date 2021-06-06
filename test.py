import os
os.chdir("C:/Users/johnson1/Desktop/Program/Python/R_project")
from bs4 import BeautifulSoup
import requests
import urllib.request as req
import json

def get_access_token():
  #API網址
  url = "https://account.kkbox.com/oauth2/token" 
  #標頭
  headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Host": "account.kkbox.com"
  }
  #參數
  data = {
    "grant_type": "client_credentials",
    "client_id": "86b4143aa500ae41e800ceef0e5d7437",
    "client_secret": "940af67c66f936703966539f364fe7b6"
  }
  access_token = requests.post(url, headers=headers, data=data)
  return access_token.json()["access_token"]

def get_charts_tracks(chart_id):
  #存取憑證
  access_token = get_access_token()
  #取得音樂排行榜列表中的歌曲API網址
  url = "https://api.kkbox.com/v1.1/charts/" + chart_id + "/tracks"
  #標頭
  headers = {
    "accept": "application/json",
    "authorization": "Bearer " + access_token
  }
  #參數
  params = {
    "territory": "TW"  #台灣領域
  }
  response = requests.get(url, headers=headers, params=params)
  result = response.json()["data"]
  songs = []
  for item in result:
    songs.append(([item["name"], item["url"]]))
  return songs

chart_id = "Gl3QrpqQJoxtra-JLt"
print(get_charts_tracks(chart_id))
