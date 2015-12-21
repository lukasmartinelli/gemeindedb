#!/usr/bin/env python
"""Extract the dimensions of CSV files from PX Axis BFS downloads
Usage:
  extract_px_dimensions.py <csv_file>
  extract_px_dimensions.py (-h | --help)
  extract_px_dimensions.py --version
Options:
  -h --help         Show this screen.
  --version         Show version.
"""
import csv
import sys
from docopt import docopt


def extract_values(reader):

    def parse_row(community, nationality, row):
        parts = community.split(' ')
        community_id = parts[0]
        community_name = " ".join(parts[1:])
        return [community_id, community_name, nationality] + row[4:]

    def skip():
        next(reader)

    def parse_header_row():
        header_row = next(reader)
        additional_fields = ['community_id', 'community_name', 'nationality']
        return additional_fields + header_row[4:]

    yield parse_header_row()
    for row in reader:
        is_community = len(row) > 1 and row[1].startswith('......')
        if is_community:
            community = row[1].replace('......', '')

            skip()
            yield parse_row(community, 'Switzerland', next(reader))
            skip()
            yield parse_row(community, 'Foreign', next(reader))


if __name__ == '__main__':
    args = docopt(__doc__, version='0.1')

    with open(args.get('<csv_file>')) as csv_file:
        reader = csv.reader(csv_file, delimiter='\t', quotechar='"')
        writer = csv.writer(sys.stdout, delimiter='\t', quotechar='"')

        for row in extract_values(reader):
            writer.writerow(row)
