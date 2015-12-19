# Open Data Statistics about Swiss Municipalities

A ready to use PostGIS database with prepared geo data and statistics
about swiss municipalities.

## Statistical Data

The data is available in the TSV format and is from the
[Statistical Atlas of Switzerland](http://www.bfs.admin.ch/bfs/portal/en/index/regionen/thematische_karten/02.html).
Because it is available as set of files you are free to use the files in the prepared format for your
own purposes.

## Geographical Data

Additional to the statistical data there is also geographical data which is mostly the administrative
boundaries of the municipalities.

## Import

Using [my PostgreSQL import tool pgfutter](https://github.com/lukasmartinelli/pgfutter) the TSV files
are automatically imported into the PostGIS database.

On the imported tables we then execute a ETL process to bring the data into a common schema
where it is easy to work with.
