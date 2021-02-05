'''
Replay just replays what you have posted.
'''

from flask import Flask,make_response, request
from flask import json
from flask_restful import Resource, Api
from threading import Lock
import os

app = Flask(__name__)
api = Api(app)

mutex=Lock()
REPLAYD_FILE='/tmp/replayd.json'

class ReplayD(Resource):
    def perform_operation(http_func):
        def wrapper(self):
            global mutex
            mutex.acquire()
            try:
                output = http_func(self)
            except Exception as ex:
                mutex.release()
                raise ex
            mutex.release()
            return output
        
        return wrapper

    @perform_operation
    def get(self):
        user_data = None

        if os.path.exists(REPLAYD_FILE):
            with open(REPLAYD_FILE) as json_file:
                user_data = json.load(json_file)
        return user_data

    @perform_operation
    def post(self):
        user_data = request.get_json()
        with open(REPLAYD_FILE, 'w') as f:
            json.dump(user_data, f)

        return "Successfully accepted",201

    @perform_operation
    def put(self):
        user_data = request.get_json()
        with open(REPLAYD_FILE, 'w') as f:
            json.dump(user_data, f)

        return "Successfully updated"

api.add_resource(ReplayD,'/')

if __name__ == "__main__":
    app.run("0.0.0.0",port=6080, debug=True)
