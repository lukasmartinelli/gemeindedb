# Open Data Statistics about Swiss Communities [![Build Status](https://travis-ci.org/lukasmartinelli/gemeindedb.svg)](https://travis-ci.org/lukasmartinelli/gemeindedb)

The goal of the project is to aggregate statistics about swiss communities in one places.
Most of the data is from the [BFS](http://www.bfs.admin.ch/) and is transformed
to TSV files.  The TSV format makes it easy to get started with the data and doing some real work with it
instead of looking through XLSX files.

The project also contains a ETL process to get the data into PostgreSQL and clean it up.

## Statistical Data

The raw XLSX data is from the [Statistical Atlas of Switzerland](http://www.bfs.admin.ch/bfs/portal/en/index/regionen/thematische_karten/02.html) and is in the folder `rawdata`.
This data is preprocessed and converted into TSV files in the folder `data`.
You are free to use the TSV files in `data` for your own purposes.

## Import

Using [my PostgreSQL import tool pgfutter](https://github.com/lukasmartinelli/pgfutter) the TSV files
are automatically imported into the PostgreSQL database.

From the import tables a new relational schema is built to bring the data into a snowflake schema
where it is easier to work with it.

To run a import into the `postgres` container you first need to start the database container.

```
docker-compose up -d postgres
```

And then run the import of the data.

```
docker-compose run import
```

## Convert XLSX to TSV

The docker container `convert` will convert the XLSX files in `rawdata` into TSV files in `data`.

```
docker-compose run convert
```
