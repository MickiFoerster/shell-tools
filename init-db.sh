#!/bin/bash

CONTAINER_NAME=postgres-for-testing

#set -x 
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
    sudo apt install postgresql-client-common || exit 1
fi

if ! [ -x "$(command -v sqlx)" ]; then
    # option --version=0.5.7  for certain version
    cargo install sqlx-cli --no-default-features --features postgres || exit 1
fi

if [ ! -d migrations ]; then
    echo "There is no migrations folder in this directory"
    exit 1
fi

if [[ "${DOCKER_TAG}" == "" ]]; then
    DOCKER_TAG=latest
fi


DB_USER=${POSTGRES_USER:=postgres}
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
DB_NAME="${POSTGRES_DB:=postgres}"
DB_PORT="${POSTGRES_PORT:=5432}"

# If container is already running then destroy old instance
if docker container ls | grep -q ${CONTAINER_NAME}; then
    docker kill ${CONTAINER_NAME} 
fi

# Start docker container
gnome-terminal -- docker run \
-e POSTGRES_USER=${DB_USER} \
-e POSTGRES_PASSWORD=${DB_PASSWORD} \
-e POSTGRES_DB=${DB_NAME} \
-p "${DB_PORT}":5432 \
--name "${CONTAINER_NAME}" \
--rm \
postgres:${DOCKER_TAG} \
postgres -N 2048 # ^ Increased maximum number of connections for testing purposes

# Keep pinging Postgres until it's ready to accept commands
export PGPASSWORD="${DB_PASSWORD}"
counter=1
until psql -h "localhost" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q' 2>/dev/null; do
    sleep 0.1
    let counter=${counter}+1
    if [[ ${counter} -gt 10 ]]; then
        >&2 echo "Postgres is still unavailable - sleeping"
    fi
    if [[ ${counter} -gt 20 ]]; then
        echo "could not start docker container"
        exit 1
    fi
done
>&2 echo "Postgres is up and running on port ${DB_PORT}!"

export DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}
echo "Remember so set the following env variable:"
echo "export DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}"
echo "export PGHOST=localhost"
echo "export PGPORT=${DB_PORT}"
echo "export PGUSER=${DB_USER}"
echo "export PGPASSWORD=${DB_PASSWORD}"

if [ -d migrations ]; then
    sqlx database create
    sqlx migrate run
fi
>&2 echo "Postgres has been migrated, ready to go!"


if [[ "${FIXTURES}" != "" ]]; then
    if [[ -d "${FIXTURES}" ]]; then
        cat "${FIXTURES}/*" | psql
    fi
fi

# start pgAdmin4 container
#docker run -p 80:80 \
#    -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
#    -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
#    -d dpage/pgadmin4

