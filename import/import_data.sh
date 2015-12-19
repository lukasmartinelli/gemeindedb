#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly SCHWEIZERDB_DB=${SCHWEIZERDB_DB:-schweizerdb}
readonly SCHWEIZERDB_USER=${SCHWEIZERDB_USER:-suisse}
readonly SCHWEIZERDB_PASSWORD=${SCHWEIZERDB_PASSWORD:-suisse}
readonly SCHWEIZERDB_HOST=postgis

readonly IMPORT_DIR=${IMPORT_DIR:-/data}

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

function main() {
    echo "drop schema import cascade; create schema import;" | exec_psql
    import_all
}

main
