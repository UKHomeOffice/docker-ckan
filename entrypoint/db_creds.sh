#!/usr/bin/env bash
set -eu

#echo "var is set to '$DB_CREDS'";
DATABASE_USER=$(cat $DB_CREDS | cut -d ":" -f 1)
export DATABASE_USER=$DATABASE_USER
DATABASE_PASSWORD=$(cat $DB_CREDS | cut -d ":" -f 2 | tr -d '[[:space:]]')
export DATABASE_PASSWORD=$DATABASE_PASSWORD
echo "updated DB Creds to environment variables"
