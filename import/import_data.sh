#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly SCHWEIZERDB_DB=${SCHWEIZERDB_DB:-schweizerdb}
readonly SCHWEIZERDB_USER=${SCHWEIZERDB_USER:-suisse}
readonly SCHWEIZERDB_PASSWORD=${SCHWEIZERDB_PASSWORD:-suisse}
readonly SCHWEIZERDB_HOST=db

readonly IMPORT_DIR=${IMPORT_DIR:-/data}
readonly BUILD_SCHEMA_SQL_FILE="build_schema.sql"

readonly GEODATA_DIR=${GEODATA_DIR:-/geodata}
COUNTRY_GEOJSON="$GEODATA_DIR/switzerland_country_boundaries.geojson"
CANTON_GEOJSON="$GEODATA_DIR/switzerland_canton_boundaries.geojson"
COMMUNITY_GEOJSON="$GEODATA_DIR/switzerland_community_boundaries.geojson"

function import_tsv() {
    local tsv_file="$1"
    pgfutter \
        --host "$SCHWEIZERDB_HOST" \
        --port "5432" \
        --dbname "$SCHWEIZERDB_DB" \
        --username "$SCHWEIZERDB_USER" \
        --pass "$SCHWEIZERDB_PASSWORD" \
    csv --delimiter $'\t' "$tsv_file"
}

function exec_psql() {
    PG_PASSWORD="$SCHWEIZERDB_PASSWORD" psql \
        --host="$SCHWEIZERDB_HOST" \
        --port=5432 \
        --dbname="$SCHWEIZERDB_DB" \
        --username="$SCHWEIZERDB_USER"
}

function import_all() {
    for tsv_file in $IMPORT_DIR/*.tsv; do
        echo "Importing $tsv_file"
        import_tsv "$tsv_file"
    done
}

function import_geojson() {
    local geojson_file=$1
    local table_name=$2

    echo "$geojson_file"

    PGCLIENTENCODING=UTF8 ogr2ogr \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    PG:"dbname=$SCHWEIZERDB_DB user=$SCHWEIZERDB_USER host=$SCHWEIZERDB_HOST port=5432" \
    "$geojson_file" \
    -nln "$table_name"
}

function import_geodata() {
    echo "Importing geographical data"

    import_geojson "$COUNTRY_GEOJSON" "import.country_boundaries"
    import_geojson "$CANTON_GEOJSON" "import.canton_boundaries"
    import_geojson "$COMMUNITY_GEOJSON" "import.community_boundaries"
}

function main() {
    echo "drop schema import cascade; create schema import;" | exec_psql
    import_all
    import_geodata
    cat "$BUILD_SCHEMA_SQL_FILE" | exec_psql
}

main
