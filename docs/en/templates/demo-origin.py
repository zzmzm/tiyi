#!/usr/bin/env python3
"""Local documentation origin. Bind to loopback; do not expose as an app."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json

class Demo(BaseHTTPRequestHandler):
    def reply(self, status, data):
        body = json.dumps(data).encode()
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        self.reply(200, {'message': 'Hello from the origin'})

    def do_POST(self):
        size = int(self.headers.get('Content-Length', '0'))
        if size > 65536:
            self.reply(413, {'error': 'demo limit is 64 KiB'})
            return
        self.rfile.read(size)
        # Deliberately accepts any small body: Tiyi performs validation.
        self.reply(200, {'message': 'Order received'})

ThreadingHTTPServer(('127.0.0.1', 9000), Demo).serve_forever()
