import wikipedia
import sys
import csv


def try_find_page(query):
    try:
        return wikipedia.page(query)
    except wikipedia.exceptions.PageError:
        return None


if __name__ == '__main__':
    wikipedia.set_lang("de")
    writer = csv.writer(sys.stdout, delimiter='\t', quoting=csv.QUOTE_ALL)
    reader = csv.reader(sys.stdin, delimiter='\t')

    for row in reader:
        zipcode, bfs_id, canton_abbreviation, name = row

        try:
            page = try_find_page(name + ' ' + zipcode)
            if not page:
                page = try_find_page(name + ' ' + canton_abbreviation)
            if not page:
                page = try_find_page(name)
        except wikipedia.exceptions.DisambiguationError as err:
            sys.stderr.write('Cannot find article: %sn' % str(err))
            pass

        if not page:
            continue

        imgs = dict(enumerate(page.images))

        writer.writerow([
            bfs_id, zipcode, name, page.url,
            imgs.get(0), imgs.get(1), imgs.get(2),
            imgs.get(3), imgs.get(4), imgs.get(5)]
        )
