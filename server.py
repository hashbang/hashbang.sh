#!/usr/bin/python2.7

import os
import sys
import csv
import ldap
from subprocess import check_call, CalledProcessError
from flask import Flask, send_from_directory, redirect, request, make_response
from flask.ext.restful import Resource, Api
from flask.ext.restful.reqparse import RequestParser
from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from provisor import Provisor
from provisor.utils import validate_pubkey as pubkey
from provisor.utils import validate_username as username

app = Flask(__name__)

api = Api(app)

p = Provisor(
    uri="ldap://ldap.hashbang.sh",
    user ="cn=provisor,ou=Admin,dc=hashbang,dc=sh",
    password=os.environ['LDAP_PASSWORD'],
    user_base="ou=People,dc=hashbang,dc=sh",
    group_base="ou=Group,dc=hashbang,dc=sh",
    servers_base="ou=Servers,dc=hashbang,dc=sh",
)

certfile = os.path.join(os.getcwd(), "certs/server.crt")
keyfile = os.path.join(os.getcwd(), "certs/server.key")
https_port = 4443
http_port = 8080

@api.representation('text/plain')
def output_plain(data, code, headers=None):
    lines=[]
    for server,stats in data.items():
        line = [server]
        for key,val in stats.items():
            line.append(str(val))
        lines.append("|".join(line))
    data = "\n".join(lines)
    resp = make_response(data, code)
    resp.headers.extend(headers or {})
    return resp

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
            p.add_user(
                username=str(args['user']),
                pubkey=args['key'],
                hostname='ny1.hashbang.sh'
            )
        except ldap.SERVER_DOWN:
            return { 'message': 'Unable to connect to LDAP server'}, 400
        except ldap.ALREADY_EXISTS:
            return { 'message': 'User already exists'}, 400
        except:
            sys.stderr.write("Unexpected Error: %s\n" % sys.exc_info()[0])
            return { 'message': 'User creation script failed'}, 400

        return {'message': 'success'}

class ServerStats(Resource):

    def get(self,out_format='json'):
        try:
            server_stats = p.server_stats()
        except ldap.SERVER_DOWN:
            return { 'message': 'Unable to connect to LDAP server'}, 400

        return server_stats
                

api.add_resource(UserCreate, '/user/create')
api.add_resource(ServerStats, '/server/stats')

@app.route('/',methods=["GET"])
def root():
    useragent = request.headers.get('User-Agent')
    if 'curl' in useragent and not request.is_secure:
        return send_from_directory('static','warn.sh')
    if not os.path.isfile(certfile) and not os.path.isfile(keyfile):
        return send_from_directory('static','index.html')
    if request.is_secure:
        return send_from_directory('static','index.html')
    return redirect(request.url.replace("http://", "https://"))

if __name__ == '__main__':

    if os.path.isfile(certfile) and os.path.isfile(keyfile):
        https_server = HTTPServer(
          WSGIContainer(app),
          ssl_options={
              "certfile": certfile,
              "keyfile": keyfile,
          }
        )
        https_server.listen(https_port)

    http_server = HTTPServer(WSGIContainer(app))
    http_server.listen(http_port)
    IOLoop.instance().start()
