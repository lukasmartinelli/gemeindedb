# Open Data Statistics about Swiss Communities [![Build Status](https://travis-ci.org/lukasmartinelli/gemeindeinfo.svg)](https://travis-ci.org/lukasmartinelli/gemeindedb)

> :warning: This repository is no longer maintained by Lukas Martinelli.

The goal of the project is to collect statistics about swiss communities in one place and provide
TSV downloads and a website to show of some nice statistics.

http://gemeindeinfo.lukasmartinelli.ch/

The data is from the [BFS](http://www.bfs.admin.ch/) and is transformed
to TSV files.  The TSV format makes it easy to get started with the data and doing some real work with it
instead of looking through XLSX or PX files.

The project also contains a ETL process to transform the data into a relational schema with PostgreSQL.

[![Screenshot of info portal](screenshot.png)](http://gemeindeinfo.lukasmartinelli.ch/)

## Statistical Data

The collected data files are in the folder `data`.
You are free to use the TSV files in `data` for your own purposes.

## Data Sources

| File                                   | Source                                                                                                                                         |
|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| politische_gemeinden_2015.tsv          | STATATLAS Institutionelle Gliederungen > Politische Gemeinden 2015                                                                             |
| kantone_1997.tsv                       | STATATLAS Institutionelle Gliederungen > Kantone 1997                                                                                          |
| mittlere_wohnbevölkerung_1981_2014.tsv | STAT-TAB Gemeindestatistik1981-2014 nach demographischen Komponenten, institutionellen Gliederungen, Staatsangehörigkeit, Geschlecht und Jahr  |
| bauvorhaben_1995_2012.tsv              | STAT-TAB Bauvorhaben nach Art der Auftraggeber, Art der Bauwerke und Art der Arbeiten
| bauinvestitionen_1995_2012.tsv         | STAT-TAB Bauinvestitionen nach Art der Auftraggeber und nach Kategorie der Bauwerke
| beschaeftigte_grossunternehmen_2013.tsv| Arbeitsstätten und Beschäftigte nach Gemeinde, Wirtschaftssektor und Grössenklasse (STATENT)
| beschaeftigte_kleinunternehmen_2013.tsv| Arbeitsstätten und Beschäftigte nach Gemeinde, Wirtschaftssektor und Grössenklasse (STATENT)
| beschaeftigte_mittlere_unternehmen_2013.tsv| Arbeitsstätten und Beschäftigte nach Gemeinde, Wirtschaftssektor und Grössenklasse (STATENT)
| beschaeftigte_primaersektor_2013.tsv| Arbeitsstätten und Beschäftigte nach Gemeinde, Wirtschaftssektor und Grössenklasse (STATENT)
| beschaeftigte_sekundaersektor_2013.tsv| Arbeitsstätten und Beschäftigte nach Gemeinde, Wirtschaftssektor und Grössenklasse (STATENT)
| beschaeftigte_tertiaersektor_2013.tsv| Arbeitsstätten und Beschäftigte nach Gemeinde, Wirtschaftssektor und Grössenklasse (STATENT)
| bevoelkerung_bestand_1981_2014.tsv   | Gemeindestatistik 1981-2014 nach demographischen Komponenten, institutionellen Gliederungen, Staatsangehörigkeit, Geschlecht und Jahr
| buergerrecht_erwerb_1981_2014.tsv    | Erwerb des Schweizer Bürgerrechts nach institutionellen Gliederungen, Geschlecht und (ehemalige) Staatsangehörigkeit
| einwanderung_1981_2014.tsv           | Wanderung der ständigen Wohnbevölkerung nach institutionellen Gliederungen, Geschlecht, Staatsangehörigkeit und Migrationstyp
| geburt_1981_2014.tsv                 | Lebendgeburten nach institutionellen Gliederungen, Geschlecht und Staatsangehörigkeit des Kindes und nach Altersklasse der Mutter
| geburtenueberschuss_1981_2014.tsv    | Gemeindestatistik 1981-2014 nach demographischen Komponenten, institutionellen Gliederungen, Staatsangehörigkeit, Geschlecht und Jahr
| marriages_1969_2014.tsv              | Heiraten nach institutionellen Gliederungen und Staatsangehörigkeit der Ehepartner
| scheidungen_1969_2014.tsv            | Scheidungen nach institutionellen Gliederungen, Ehedauer und Staatsangehörigkeit (bei der Scheidung) der Ehegatten
| todesfaelle_1981_2014.tsv.           | Todesfälle nach institutionellen Gliederungen, Geschlecht, Staatsangehörigkeit, Zivilstand und Altersklasse






## Workflow

We use [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) to make the workflow portable.
Using [my PostgreSQL import tool pgfutter](https://github.com/lukasmartinelli/pgfutter) the TSV files
are automatically imported into the PostgreSQL database.

To run a import into the `postgres` container you first need to start the database container.

```
docker-compose up -d postgres
```

And then run the import of the data.

```
docker-compose run import
```

From the import tables a new relational schema is created where it is easier to work with the data.

```
docker-compose run schema
```

Start up the API gateway to the database which will listen to port `3000` of the Docker host.

```
docker-compose up -d api
```

For the website all data from the API is actually scraped down and put into a folder so that it works
on GitHub pages without requiring a server. After the data is scraped from the API it is placed into the `apidata` folder.

```
docker-compose run pregenerate
```
