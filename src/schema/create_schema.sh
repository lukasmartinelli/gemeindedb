#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly DB_NAME=${DB_NAME:-gemeindedb}
readonly DB_USER=${DB_USER:-suisse}
readonly DB_PASSWORD=${DB_PASSWORD:-suisse}
readonly DB_HOST=postgres

readonly SQL_FILE="schema.sql"

function exec_psql() {
    PG_PASSWORD="$DB_PASSWORD" psql \
        -v ON_ERROR_STOP=1 \
        --host="$DB_HOST" \
        --port=5432 \
        --dbname="$DB_NAME" \
        --username="$DB_USER"
}

function main() {
    cat "$SQL_FILE" | exec_psql
}

main
