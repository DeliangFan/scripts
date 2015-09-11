import gevent
from gevent import sleep
from gevent.coros import BoundedSemaphore
import random


sem = BoundedSemaphore(2)
def worker(n):
    sleep(random.random())
    sem.acquire()
    print "Start worker" + str(n)
    sleep(random.random())
    print "End worker" + str(n)
    sem.release()


def main():
    thread = [gevent.spawn(worker, n) for n in range(10)]
    gevent.joinall(thread)


if __name__ == '__main__':
    main()
