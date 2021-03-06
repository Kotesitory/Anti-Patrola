from http.server import HTTPServer, SimpleHTTPRequestHandler
import ssl


httpd = HTTPServer(('0.0.0.0', 443), SimpleHTTPRequestHandler)

httpd.socket = ssl.wrap_socket (httpd.socket,
        keyfile="./private.key",
        certfile='./certificate.crt', server_side=True)

httpd.serve_forever()