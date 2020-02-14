##
## EPITECH PROJECT, 2020
## Carillon
## File description:
## run
##

from flask import *
import pyrebase as pb
from api import API_KEY

config = {
  "apiKey": API_KEY,
  "authDomain": "carillion-9c536.firebaseapp.com",
  "databaseURL": "https://carillion-9c536.firebaseio.com",
  "projectId": "carillion-9c536",
  "storageBucket": "carillion-9c536.appspot.com",
  "serviceAccount": "./firebase-private-key.json",
  "messagingSenderId": "507685840771"
}

fb = pb.initialize_app(config)
db = fb.database()

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "GET":
        return render_template("index.html")
    else:
        if not request.form["email"] in db.child("emails").get().val().values():
            db.child("emails").push(request.form["email"])
        return render_template("index_thanks.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port="5000", debug=True)