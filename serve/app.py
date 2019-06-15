# -*- coding: utf-8 -*-
import glob
from flask import Flask
import requests
import pyrebase
import subprocess as sp

app = Flask(__name__)

config = {
    'apiKey': "AIzaSyCdMd1poqri4WFvxJGE8wAasxD2S7h4cFY",
    'authDomain': "remember-4ec53.firebaseapp.com",
    'databaseURL': "https://remember-4ec53.firebaseio.com",
    'storageBucket': "remember-4ec53.appspot.com"
}

firebase = pyrebase.initialize_app(config)

@app.route('/api/v1/img/<img_id>')
def index(img_id):
    storage = firebase.storage()
    # storageに画像登録(server test用)
    # storage.child('/image/' + img_id +'/image002.png').put('./img/image002.png')
    # storage.child('/image/' + img_id +'/image003.png').put('./img/image003.png')
    # storage.child('/image/' + img_id +'/image000.png').put('./img/image000.png')

    # download(時間があればいい感じのコードにしたい)
    storage.child('/image/' + img_id + '/image000.png').download('./save_img/image000.png')
    storage.child('/image/' + img_id + '/image001.png').download('./save_img/image001.png')
    storage.child('/image/' + img_id + '/image002.png').download('./save_img/image002.png')
    storage.child('/image/' + img_id + '/image003.png').download('./save_img/image003.png')
    

    # 画像の名前と大きさによって変更(いい感じにしたい)
    cmd='ffmpeg \
    -loop 1 -t 5 -i ./img/image000.png \
    -loop 1 -t 5 -i ./img/image001.png \
    -loop 1 -t 5 -i ./img/image002.png \
    -loop 1 -t 5 -i ./img/image003.png \
    -filter_complex \
    "[0:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=out:st=4:d=1[v0]; \
    [1:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v1]; \
    [2:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v2]; \
    [3:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v3]; \
    [v0][v1][v2][v3]concat=n=4:v=1:a=0,format=yuv420p[v]" -map "[v]" ./save_mp4/out.mp4'
    sp.call(cmd,shell=True)

    storage.child('/mp4/' + img_id +'/out.mp4').put('./save_mp4/out.mp4')

    return 'hello'


if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=80)