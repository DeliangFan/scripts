import gevent
from gevent.event import AsyncResult


a = AsyncResult()


def setter():
    print "I am setter."
    gevent.sleep(3)
    a.set("Hello")


def waiter():
    print "I am waiter"
    print a.get()


if __name__ == '__main__':
    gevent.joinall([gevent.spawn(waiter), gevent.spawn(setter)])
