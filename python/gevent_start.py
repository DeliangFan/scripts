import gevent
import time


def bar():
    print "This is bar!"
    gevent.sleep(1)
    print "This is bar again!"

def foo():
    print "This is foo!"
    gevent.sleep(10)
    print "This is foo again!"

gevent.joinall([gevent.spawn(foo), gevent.spawn(bar)])
