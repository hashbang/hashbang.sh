#!/usr/bin/python2.7

import os
from subprocess import check_call, CalledProcessError
from flask import Flask, send_from_directory
from flask.ext.restful import Resource, Api
from flask.ext.restful.reqparse import RequestParser
from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from provisor.utils import validate_pubkey as pubkey
from provisor.utils import validate_username as username

app = Flask(__name__)
api = Api(app)

class UserCreate(Resource):
    def __init__(self):
        self.reqparse = RequestParser()
        self.reqparse.add_argument(
            'user',
            type = username,
            required = True,
            location = 'json'
        )
        self.reqparse.add_argument(
            'key',
            type = pubkey,
            required = True,
            location = 'json'
        )
        super(UserCreate, self).__init__()
        
    def post(self):
        args = self.reqparse.parse_args()
        try:
            check_call(
                [ 'sudo',
                  '%s/bin/provisor-create' % os.getcwd(),
                  args['user'],
                  args['key']
                ],
                timeout=5
            )
        except CalledProcessError as e:
            if e.returncode == 1:
                return {'message': 'User creation script failed'}
            elif e.returncode == 2:
                return {'message': 'Username error/already taken'}
            elif e.returncode == 3:
                return {'message': 'Key type must be ssh-dsa or ssh-rsa.'}

       
        return {'message': 'success'}

api.add_resource(UserCreate, '/user/create')

@app.route('/',methods=["GET"])
def root():
    return send_from_directory('static','index.html')

if __name__ == '__main__':
    http_server = HTTPServer(WSGIContainer(app))
    http_server.listen(5000)
    IOLoop.instance().start()
