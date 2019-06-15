# -*- coding: utf-8 -*-
import glob
from flask import Flask
import requests
import pyrebase

app = Flask(__name__)

config = {
    'apiKey': "AIzaSyCdMd1poqri4WFvxJGE8wAasxD2S7h4cFY",
    'authDomain': "remember-4ec53.firebaseapp.com",
    'databaseURL': "https://remember-4ec53.firebaseio.com",
    'storageBucket': "remember-4ec53.appspot.com"
}

firebase = pyrebase.initialize_app(config)

# files = glob.glob('./img/*.png')
# for f in files:
#     img = cv2.imread(f)
#     img = cv2.resize(img, (640,480))
#     # print(img)
#     video.write(img)

# video.release()

@app.route('/')
def index():
    storage = firebase.storage()
    # metadata = {
    #     contentType: 'image/png',
    # }
    # files = glob.glob('./img/*.png')
    # img = cv2.imread(files[0])
    # photo_path = requests.get('https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=format%2Ccompress&cs=tinysrgb&dpr=1&w=500').content
    #.childの中は保存するStorage内のディレクトリ
    # storage.child('google.jpg').put(photo_path, user['idToken'])
    storage.child("/img/image001.png").put('./img/image000.png')
    return 'hello'



if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=80)