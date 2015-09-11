from gevent.server import StreamServer


def handle(socket, address):
    socket.send("hello from wsfdl's mac!")
    for i in range(5):
        socket.send(str(i) + '\n')
    socket.close()


server = StreamServer(('0.0.0.0', 5000), handle)
server.serve_forever()
