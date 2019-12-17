#!/usr/bin/python2.7

import os
import sys
import traceback
import base64
import re
import ssl
from flask import Flask, send_file, send_from_directory, redirect, request, make_response
from flask_restful import Resource, Api
from flask_restful.reqparse import RequestParser
import requests
from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from reserved import RESERVED_USERNAMES

app = Flask(__name__)
app.config['RESTFUL_JSON'] = {"indent": 4}

api = Api(app)

certfile = os.path.join(os.getcwd(), "certs/server.crt")
keyfile = os.path.join(os.getcwd(), "certs/server.key")
https_port = 4443
http_port = 8080


def validate_pubkey(value):
    if len(value) > 8192 or len(value) < 80:
      raise ValueError("Expected length to be between 80 and 8192 characters")

    value = value.replace("\"", "").replace("'", "").replace("\\\"", "")
    value = value.split(' ')
    types = [ 'ecdsa-sha2-nistp256', 'ecdsa-sha2-nistp384',
              'ecdsa-sha2-nistp521', 'ssh-rsa', 'ssh-dss', 'ssh-ed25519' ]
    if value[0] not in types:
        raise ValueError(
            "Expected " + ', '.join(types[:-1]) + ', or ' + types[-1]
        )

    return "%s %s" % (value[0], value[1])


def validate_username(value):

    # Regexp must be kept in sync with
    #  https://github.com/hashbang/hashbang.sh/blob/master/src/hashbang.sh#L186-196
    if re.compile(r"^[a-z][a-z0-9]{,30}$").match(value) is None:
        raise ValueError('Username is invalid')

    if value in RESERVED_USERNAMES:
        raise ValueError('Username is reserved')

    return value

@api.representation('text/plain')
def output_plain(data, code, headers=None):
    lines = []
    for server in data:
        line = [
            server['name'],
            '',
            'DE',
            'N/A',
            str(server['maxusers'])
        ]
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
            type = validate_username,
            required = True,
            location = 'json'
        )
        self.reqparse.add_argument(
            'key',
            type = validate_pubkey,
            required = True,
            location = 'json'
        )
        self.reqparse.add_argument(
            'host',
            type = str,
            required = True,
            location = 'json'
        )
        super(UserCreate, self).__init__()

    def post(self):
        args = self.reqparse.parse_args()

        try:
            post_data = {
                "name": str(args["user"]),
                "host": args["host"],
                "data": {
                    "shell": "/bin/bash",
                    "ssh_keys": [args["key"]]
                }
            }
            r = requests.post(
                "https://userdb.hashbang.sh/passwd",
                json = post_data
            )
            print(f"{r.status_code} - {args['user']} - {r.text}")
            if r.status_code >= 400:
                data = r.json()
                return {'message': data['message']}, r.status_code
        except:
            (typ, value, tb) = sys.exc_info()
            sys.stderr.write("Unexpected Error: %s\n" % typ)
            sys.stderr.write("\t%s\n" % value)
            traceback.print_tb(tb)
            return {'message': 'User creation script failed'}, 500

        return {'message': 'success'}


class ServerStats(Resource):
    LOCATIONS = {
        "da1.hashbang.sh": {"lat": 32.8, "lon": -96.8},
        "ny1.hashbang.sh": {"lat": 40.7, "lon": -74},
        "sf1.hashbang.sh": {"lat": 37.8, "lon": -122.4},
        "to1.hashbang.sh": {"lat": 43.7, "lon": -79.4},
        "de1.hashbang.sh": {"lat": 49.4478, "lon": 11.0683},
    }

    def get(self, out_format='json'):
        try:
            data = requests.get("https://userdb.hashbang.sh/hosts").json()
        except:
            return {'message': 'Unable to connect to server'}, 500

        for idx, s in enumerate(data):
            server_host = s['name']
            if server_host in self.LOCATIONS.keys():
                data[idx].update({'coordinates': self.LOCATIONS[server_host]})

        return data


api.add_resource(UserCreate, '/user/create')
api.add_resource(ServerStats, '/server/stats')


def security_headers(response, secure=False):
    csp = "default-src 'none'; "                            \
          "style-src https://fonts.googleapis.com 'self'; " \
          "font-src https://fonts.gstatic.com; "            \
          "img-src data:; script-src 'self'; "              \
          "sandbox allow-same-origin allow-scripts; "       \
          "frame-ancestors 'none'"

    response.headers['Content-Security-Policy'] = csp
    response.headers['Referrer-Policy']         = 'no-referrer'
    response.headers['X-Content-Type-Options']  = 'nosniff'
    response.headers['X-Frame-Options']         = 'DENY'
    response.headers['X-XSS-Protection']        = '1; mode=block'

    if secure:
        response.headers['Strict-Transport-Security'] = 'max-age=31536000'

    return response


@app.route('/', methods=["GET"])
def root():
    useragent = request.headers.get('User-Agent')
    has_https = 'https_server' in globals()

    if 'curl' in useragent and not request.is_secure:
        resp = send_from_directory('static', 'warn.sh.asc')
    elif not has_https or request.is_secure:
        resp = send_from_directory('static', 'index.html')
    else:
        return redirect(request.url.replace("http://", "https://"))

    return security_headers(resp, secure=request.is_secure)


@app.route('/LICENSE.md', methods=['GET'])
def license():
    return security_headers(send_file('LICENSE.md', mimetype='text/markdown'),
                            secure=request.is_secure)

# HE.net domain validation
@app.route('/s73rmwh.txt', methods=['GET'])
def he_net():
    return security_headers(make_response('Hello IPv6!'),
                            secure=request.is_secure)

@app.route('/assets/<path:filename>', methods=['GET'])
def assets(filename):
    return security_headers(send_from_directory('src', filename),
                            secure=request.is_secure)

if __name__ == '__main__':

    if os.path.isfile(certfile) and os.path.isfile(keyfile):
        ssl_ctx = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
        ssl_ctx.load_cert_chain(certfile, keyfile)

        # Protocol options: allow TLSv1.1 and later
        ssl_ctx.options |= ssl.OP_NO_SSLv2
        ssl_ctx.options |= ssl.OP_NO_SSLv3
        ssl_ctx.options |= ssl.OP_NO_TLSv1

        # Cipher options: strong ciphers, follow server preferences
        ssl_ctx.set_ciphers("ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384")
        ssl_ctx.options |= ssl.OP_CIPHER_SERVER_PREFERENCE

        # Key exchange: strong prime curve, no point reuse
        ssl_ctx.set_ecdh_curve('prime256v1')
        ssl_ctx.options |= ssl.OP_SINGLE_ECDH_USE

        https_server = HTTPServer(
            WSGIContainer(app),
            ssl_options=ssl_ctx
        )
        https_server.listen(https_port)

    http_server = HTTPServer(WSGIContainer(app))
    http_server.listen(http_port)
    IOLoop.instance().start()
