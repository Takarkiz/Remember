# -*- coding: utf-8 -*-
import pyrebase
config = {
    'apiKey': "AIzaSyCdMd1poqri4WFvxJGE8wAasxD2S7h4cFY",
    'authDomain': "remember-4ec53.firebaseapp.com",
    'databaseURL': "https://remember-4ec53.firebaseio.com",
    'storageBucket': "remember-4ec53.appspot.com"
}
firebase = pyrebase.initialize_app(config)
storage = firebase.storage()
storage.child("/img/image001.png").put('./img/image000.png')