#!/bin/bash

set -x
set -eo pipefail

POSTGRES_USER=${POSTGRES_USER:=postgres}
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:=password}"
POSTGRES_PORT="${POSTGRES_PORT:=5432}"
POSTGRES_DB="${POSTGRES_DB:=postgres}"
export DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1:${POSTGRES_PORT}/${POSTGRES_DB}

rm -rf migrations &&
sqlx migrate add create_key_value_store_table
cd migrations
f=$(ls)
cd -

cat <<EOM > migrations/$f
CREATE TABLE values(
    id uuid NOT NULL,
    PRIMARY KEY (id),
    key TEXT NOT NULL UNIQUE,
    value TEXT NOT NULL,
    inserted_at timestamptz NOT NULL
);
EOM

sqlx migrate run
