# -*- coding: utf-8 -*-
import cv2
import glob

fourcc = cv2.VideoWriter_fourcc('m','p','4','v')
video = cv2.VideoWriter('video.mp4', fourcc, 1.0, (640, 480))

files = glob.glob('./img/*.png') # .jpgのみ列挙
for f in files:
    img = cv2.imread(f)
    img = cv2.resize(img, (640,480))
    # print(img)
    video.write(img)

video.release()