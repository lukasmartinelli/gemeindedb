# Open Data Statistics about Swiss Communities

Raw data from the [BFS](http://www.bfs.admin.ch/) about swiss communities
available as TSV downloads.

The TSV format makes it easy to get started with the data and doing some real work with it
instead of looking through XLSX files.

The project also contains a ETL process to get the data into PostgreSQL and clean it up.

## Statistical Data

The data is available in the TSV format and is from the
[Statistical Atlas of Switzerland](http://www.bfs.admin.ch/bfs/portal/en/index/regionen/thematische_karten/02.html).
Because it is available as set of files you are free to use the files in the prepared format for your
own purposes.

## Import

Using [my PostgreSQL import tool pgfutter](https://github.com/lukasmartinelli/pgfutter) the TSV files
are automatically imported into the PostgreSQL database.

From the import tables a new relational schema is built to bring the data into a snowflake schema
where it is easier to work with it.
