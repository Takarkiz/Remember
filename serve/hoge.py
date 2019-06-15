# -*- coding: utf-8 -*-
# from flask import Flask
# import os
# import glob
# from PIL import Image
# import numpy as np

# X = []
# app = Flask(__name__)

# @app.route('/')
# def index():
#     images = glob.glob(os.path.join("./img/", "*.png"))

#     # 読み込んだ画像を順に拡張
#     for i in range(len(images)):
#         img = np.array(Image.open(images[i]))
#         X.append(img /255.)
#     return img



# if __name__ == '__main__':
#     app.debug = True
#     app.run(host='0.0.0.0', port=80)

import subprocess as sp

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
 [v0][v1][v2][v3]concat=n=4:v=1:a=0,format=yuv420p[v]" -map "[v]" out.mp4'
sp.call(cmd,shell=True)