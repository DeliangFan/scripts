import gevent
from gevent.queue import Queue, Empty


queue = Queue(maxsize=3)


def worker(name):
    try:
        while True:
            message = queue.get(timeout=1)
            print name + str(message)
            gevent.sleep(0)
    except Empty:
        print "Quitting time!"


def boss():
    for i in xrange(1, 10):
        queue.put(i)
    print "Assigned all work in iteration 1."

    for i in xrange(10, 20):
        queue.put(i)
    print "Assigned all work in iteration 2."


if __name__ == '__main__':
    gevent.joinall([
        gevent.spawn(boss),
        gevent.spawn(worker, 'summer'),
        gevent.spawn(worker, 'winter'),
        gevent.spawn(worker, 'autumn')]
    )
