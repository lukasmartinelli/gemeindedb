#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly SCHWEIZERDB_DB=${SCHWEIZERDB_DB:-schweizerdb}
readonly SCHWEIZERDB_USER=${SCHWEIZERDB_USER:-suisse}
readonly SCHWEIZERDB_PASSWORD=${SCHWEIZERDB_PASSWORD:-suisse}

function create_schweizer_db() {
    echo "Creating database $SCHWEIZERDB_DB with owner $SCHWEIZERDB_USER"
    PGUSER="$POSTGRES_USER" psql --dbname="$POSTGRES_DB" <<-EOSQL
		CREATE USER $SCHWEIZERDB_USER WITH PASSWORD '$SCHWEIZERDB_PASSWORD';
		CREATE DATABASE $SCHWEIZERDB_DB WITH TEMPLATE template_postgis OWNER $SCHWEIZERDB_USER;
	EOSQL
}

create_schweizer_db
