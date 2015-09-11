import gevent


def run_forever():
    gevent.sleep(1000)


def main():
    gevent.joinall([gevent.spawn(run_forever)])


if __name__ == '__main__':
    main()
