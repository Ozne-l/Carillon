import sys
import cv2
import numpy as np

def usage():
    print ("USAGE: python3 main.py <img path>")

def check_args():
    if len(sys.argv) != 2:
        usage()
        sys.exit(84)

def load_image():
    img = cv2.imread(sys.argv[1])
    if type(img) != np.ndarray:
        print ("Error: while opening the image")
        sys.exit(84)
    return img

def to_gray_scale(img):
    return cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

def is_near_eyes(sy, eyes_rects):
    for (x, y, w, h) in eyes_rects:
        if y + int(h * 1.5) > sy:
            return True
    return False

def keep_the_two_nearest_eyes(eyes_rects):
    if len(eyes_rects) > 2:
        res = []
        for count, (x, y, w, h) in enumerate(eyes_rects):
            if len(res) < 2:
                res.append(eyes_rects[count])
            else:
                actual = 0
                for (rx, ry, rw, rh) in res:
                    actual += ry
                actual /= 2
                for idx, (rx, ry, rw, rh) in enumerate(res):
                    if (ry + y) / 2 < actual:
                        res.pop(idx)
                        res.append(eyes_rects[count])
        eyes_rects = res
    res = []
    for count, (x, y, w, h) in enumerate(eyes_rects):
        add = True
        for c, (ex, ey, ew, eh) in enumerate(eyes_rects):
            if count != c and x > ex and x < ex + ew and y > ey and y < ey + eh:
                add = False
            elif count != c and x + w > ex and x + w < ex + ew and y + h > ey and y + h < ey + eh:
                add = False
        if add:
            res.append(eyes_rects[count])
    return res

def get_faces_rects(gray, img):
    face_cascade = cv2.CascadeClassifier("./IA/haarcascades/haarcascade_frontalface_default.xml")
    eye_cascades = cv2.CascadeClassifier("./IA/haarcascades/haarcascade_eye.xml")
    smile_cascades = cv2.CascadeClassifier("./IA/haarcascades/haarcascade_smile.xml")
    faces_rects = face_cascade.detectMultiScale(gray, 1.3, 5)
    for (x, y, w, h) in faces_rects:
        img = cv2.rectangle(img, (x, y), (x + w, y + h), (255, 0, 0), 2)
        gray_rect = gray[y : y + h, x : x + w]
        eyes_rects = eye_cascades.detectMultiScale(gray_rect, 1.3, 4)
        eyes_rects = keep_the_two_nearest_eyes(eyes_rects)
        for (ex, ey, ew, eh) in eyes_rects:
            img = cv2.rectangle(img, (x + ex, y + ey), (x + ex + ew, y + ey + eh), (0, 255, 0), 2)
        smiles_rects = smile_cascades.detectMultiScale(gray_rect, 1.3, 20)
        for (sx, sy, sw, sh) in smiles_rects:
            if not is_near_eyes(sy, eyes_rects):
                img = cv2.rectangle(img, (x + sx, y + sy), (x + sx + sw, y + sy + sh), (0, 0, 255), 2)
    return img, faces_rects

def face_detection(img):
    gray = to_gray_scale(img)
    img_with_faces_rects, faces_rects = get_faces_rects(gray, img)
    return img_with_faces_rects, faces_rects

def main():
    check_args()
    img = load_image()
    img_with_faces_rects, faces_rects = face_detection(img)
    print ("Faces found :", len(faces_rects))
    cv2.imshow("img", img_with_faces_rects)
    cv2.waitKey(0)

if __name__ == "__main__":
    main()
