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


def extract_dimensions(reader):

    def parse_row(community, sex, nationality, row):
        parts = community.split(' ')
        community_id = parts[0]
        community_name = " ".join(parts[1:])
        return [community_id, community_name, sex, nationality] + row[4:]

    header_row = next(reader)
    yield ['gemeinde_id', 'gemeinde_name', 'geschlecht', 'nationalität'] + header_row[4:]

    for row in reader:
        is_community = len(row) > 1 and row[1].startswith('......')
        if is_community:
            community = row[1].replace('......', '')
            _ = next(reader)

            swiss_male_row = next(reader)
            yield parse_row(community, 'Mann', 'Schweiz', swiss_male_row)
            swiss_female_row = next(reader)
            yield parse_row(community, 'Frau', 'Schweiz', swiss_female_row)

            _ = next(reader)

            foreign_male_row = next(reader)
            yield parse_row(community, 'Mann', 'Ausland', foreign_male_row)
            foreign_female_row = next(reader)
            yield parse_row(community, 'Frau', 'Ausland', foreign_female_row)


if __name__ == '__main__':
    args = docopt(__doc__, version='0.1')

    with open(args.get('<csv_file>')) as csv_file:
        reader = csv.reader(csv_file, delimiter='\t', quotechar='"')
        writer = csv.writer(sys.stdout, delimiter='\t', quotechar='"')

        for dim_row in extract_dimensions(reader):
            writer.writerow(dim_row)
