from flask import *

app = Flask(__name__)

@app.route('/test', methods=["GET"])
def test():
    return jsonify(request.args)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port="5000", debug=True)