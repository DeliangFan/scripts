import threading
import time
import random
import Queue


BUF_SIZE = 10
q = Queue.Queue(BUF_SIZE)


class ProducerThread(threading.Thread):
    def __init__(self, name=None):
        super(ProducerThread, self).__init__()
        self.name = name


    def run(self):
        while True:
            if not q.full():
                item = random.randint(1, 10)
                q.put(item)
                time.sleep(random.randint(1, 10) * 0.1)


class ConsumerThread(threading.Thread):
    def __init__(self, name=None):
        super(ConsumerThread, self).__init__()
        self.name = name

    def run(self):
        while True:
            if not q.empty():
                item = q.get()
                print item
                time.sleep(0.1)


if __name__ == '__main__':
    p = ProducerThread(name="Producer")
    c = ConsumerThread(name="Consumer")

    p.start()
    time.sleep(1)
    c.start()
    time.sleep(1)
