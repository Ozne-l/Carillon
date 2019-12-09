from flask import *
from IA.main import face_detection
import cv2
import numpy as np
import base64

app = Flask(__name__)

@app.route('/users', methods=["POST"])
def users():
    image = request.form.get('image')
    rotate = request.form.get('rotate')
    image = base64.b64decode(image)
    npimg = np.fromstring(image, dtype=np.uint8)
    img = cv2.imdecode(npimg, cv2.IMREAD_ANYCOLOR)
    if (rotate == "true"):
        img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
    shape = img.shape
    img = cv2.resize(img, (500, int(500 * shape[0] / shape[1])))
    img_with_rects, faces_rects = face_detection(img)
    retval, buffer = cv2.imencode('.png', img_with_rects)
    png_as_text = base64.b64encode(buffer)
    response = make_response(png_as_text)
    response.headers['Content-Type'] = 'image/png'
    return response

if __name__ == '__main__':
    app.run(host="0.0.0.0", port="5000", debug=True)