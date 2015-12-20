#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly DB_NAME=${DB_NAME:-gemeindedb}
readonly DB_USER=${DB_USER:-suisse}
readonly DB_PASSWORD=${DB_PASSWORD:-suisse}
readonly DB_HOST=postgres

readonly IMPORT_DIR=${IMPORT_DIR:-/data}
readonly BUILD_SCHEMA_SQL_FILE="build_schema.sql"

function import_tsv() {
    local tsv_file="$1"
    pgfutter \
        --host "$DB_HOST" \
        --port "5432" \
        --dbname "$DB_NAME" \
        --username "$DB_USER" \
        --pass "$DB_PASSWORD" \
    csv --delimiter $'\t' "$tsv_file"
}

function exec_psql() {
    PG_PASSWORD="$DB_PASSWORD" psql \
        -v ON_ERROR_STOP=1 \
        --host="$DB_HOST" \
        --port=5432 \
        --dbname="$DB_NAME" \
        --username="$DB_USER"
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
    cat "$BUILD_SCHEMA_SQL_FILE" | exec_psql
}

main
