import os
import glob
mport Image

X = []
# 画像群の読み込み
images = glob.glob(os.path.join("./img/", "*.jpg"))

# 読み込んだ画像を順に拡張
for i in range(len(images)):
    img = np.array(Image.open(images[i]))
    X.append(img /255.)