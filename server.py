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

app = Flask(__name__)
app.config['RESTFUL_JSON'] = {"indent": 4}

api = Api(app)

certfile = os.path.join(os.getcwd(), "certs/server.crt")
keyfile = os.path.join(os.getcwd(), "certs/server.key")
https_port = 4443
http_port = 8080

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
