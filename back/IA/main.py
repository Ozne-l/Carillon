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

def main():
    check_args()
    img = load_image()
    img = to_gray_scale(img)
    img = cv2.resize(img, (500, int(500 * img.shape[0] / img.shape[1])))
    cv2.imshow("img", img)
    cv2.waitKey(0)

if __name__ == "__main__":
    main()
