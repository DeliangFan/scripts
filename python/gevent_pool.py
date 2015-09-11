import time

from gevent.pool import Pool as Gpool
from multiprocessing.pool import Pool as Mpool


def echo(i):
    time.sleep(0.1)
    return i


def main():
    mp = Mpool(10)

    run1 = [a for a in mp.imap_unordered(echo, xrange(10))]
    run2 = [a for a in mp.imap_unordered(echo, xrange(10))]
    run3 = [a for a in mp.imap_unordered(echo, xrange(10))]
    run4 = [a for a in mp.imap_unordered(echo, xrange(10))]

    print(run1 == run2 == run3 == run4)

    gp = Gpool(10) 
    run1 = [a for a in gp.imap_unordered(echo, xrange(10))]
    run2 = [a for a in gp.imap_unordered(echo, xrange(10))]
    run3 = [a for a in gp.imap_unordered(echo, xrange(10))]
    run4 = [a for a in gp.imap_unordered(echo, xrange(10))]

    print(run1 == run2 == run3 == run4)


if __name__ == '__main__':
    main()
