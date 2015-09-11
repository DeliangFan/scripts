import gevent
import time


def wait():
    gevent.sleep(10)


if __name__ == '__main__':
    timeout = gevent.Timeout(9)
    timeout.start()

    time.sleep(100) 
    try:
        thread = gevent.spawn(wait)
        thread.join()
    except Exception as e:
        print e
