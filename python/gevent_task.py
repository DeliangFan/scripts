import gevent
import random
import time


def task(t_id):
    sleep_time = random.randint(0, 10) * 0.5
    gevent.sleep(sleep_time)
    print("Task %s done with time: %s!" %(t_id, sleep_time))


def synchronous():
    for i in range(10):
        task(i)


def asynchronous():
    threads = [gevent.spawn(task, i) for i in range(10)]
    gevent.joinall(threads)


def main():
    print "Start synchronous task at %s!" % time.ctime()
    synchronous()
    print "Start asynchronous task at %s!" % time.ctime()
    asynchronous()
    print "End task at %s!" % time.ctime()


if __name__ == '__main__':
    main()
