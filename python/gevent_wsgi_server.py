from gevent.wsgi import WSGIServer


def application(environ, start_response):
    status = '200 OK'
    body = '<p>hello world</p>'
    header = [('Content-Type', 'text/html')]
    start_response(status, headers)
    return [body]


WSGIServer(('', 8000), application).serve_forever()
