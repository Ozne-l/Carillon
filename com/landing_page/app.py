##
## EPITECH PROJECT, 2020
## Carillon
## File description:
## run
##

from flask import *

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "GET":
        return render_template("index.html")
    else:
        print (request.form["email"])
        return render_template("index_thanks.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port="5000", debug=True)