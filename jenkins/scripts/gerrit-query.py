#!/usr/bin/python
"""

"""

import io
import sys
import json
import pycurl
import argparse
from StringIO import StringIO

gerrit_url = "https://review.openswitch.net/"
__version__ = '0.1'

def fetch_details(args):
    buffer = StringIO()
    c = pycurl.Curl()
    c.setopt(c.URL, gerrit_url + "/changes/?q={}&o=CURRENT_REVISION&o=CURRENT_COMMIT".format(args.review_number))
    c.setopt(c.WRITEDATA, buffer)
    c.perform()
    c.close()
    # We need to remove the first line that has the gerrit magic string
    body = '\n'.join(buffer.getvalue().split('\n')[1:])

    return json.loads(body)

def fetch_topic(args):
    buffer = StringIO()
    c = pycurl.Curl()
    c.setopt(c.URL, gerrit_url + "/changes/{}/topic".format(args.review_number))
    c.setopt(c.WRITEDATA, buffer)
    c.perform()
    c.close()
    # We need to remove the first line that has the gerrit magic string
    return '\n'.join(buffer.getvalue().split('\n')[1:])

def main():
    parser = argparse.ArgumentParser(description='Query Gerrit about reviews.')
    parser.add_argument('review_number', metavar='review', type=int,
                        help='Review number to query')
    parser.add_argument('--comment', action='store_true', help="Return the comment string")
    parser.add_argument('--topic', action='store_true', help="Return the topic string")

    args = parser.parse_args()

    if (args.comment):
        data = fetch_details(args)
        print(data[0]["revisions"][data[0]["current_revision"]]["commit"]["message"])

    if (args.topic):
        print fetch_topic(args)


if __name__ == '__main__':
    main()
