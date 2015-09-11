import gevent
from gevent.event import Event


evt1 = Event()
evt2 = Event()


def setter():
    print "A: wait for me!"
    gevent.sleep(3)
    print "I'm OK!"
    evt1.set()


def waiter():
    print "I will wait for you!"
    evt.wait()
    print "I's about me!"


def main():
    gevent.joinall([
        gevent.spawn(setter),
        gevent.spawn(waiter),
        gevent.spawn(waiter),
        gevent.spawn(waiter),
        gevent.spawn(waiter)]
    )


if __name__ == '__main__':
    main()
