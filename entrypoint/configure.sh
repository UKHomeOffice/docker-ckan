#!/usr/bin/env bash
. "${CKAN_HOME}/bin/activate"

# URL for the primary database, in the format expected by sqlalchemy (required
# unless linked to a container called 'db')
: ${DATABASE_URL:=}
# URL for solr (required unless linked to a container called 'solr')
: ${SOLR_URL:=}

set -eu

CONFIG="${CKAN_CONFIG}/ckan.ini"

abort () {
  echo "$@" >&2
  exit 1
}

write_config () {
  paster make-config ckan "$CONFIG"

  paster --plugin=ckan config-tool "$CONFIG" -e \
      "sqlalchemy.url = ${DATABASE_URL}" \
      "solr_url = ${CKAN_SOLR_URL}" \
      "solr_name = ${SOLR_NAME}" \
      "solr_password = ${SOLR_PASSWORD}" \
      "ckan.storage_path = /var/lib/ckan" \
      "email_to = disabled@example.com" \
      "error_email_from = ckan@$(hostname -f)" \
      "ckan.site_url = http://192.168.0.6"
}

link_postgres_url () {
  local user=$DB_ENV_POSTGRES_USER
  local pass=$DB_ENV_POSTGRES_PASS
  local db=$DB_ENV_POSTGRES_DB
  local host=$DB_PORT_5432_TCP_ADDR
  local port=$DB_PORT_5432_TCP_PORT
  echo "postgresql://${user}:${pass}@${host}:${port}/${db}"
}

link_solr_url () {
  local host=$SOLR_PORT_8983_TCP_ADDR
  local port=$SOLR_PORT_8983_TCP_PORT
  echo "http://${host}:${port}/solr/ckan"
}

# If we don't already have a config file, bootstrap
if [ ! -e "$CONFIG" ]; then
  if [ -z "$DATABASE_URL" ]; then
    if ! DATABASE_URL=$(link_postgres_url); then
      abort "no DATABASE_URL specified and linked container called 'db' was not found"
    fi
  fi
  if [ -z "$SOLR_URL" ]; then
    if ! SOLR_URL=$(link_solr_url); then
      abort "no SOLR_URL specified and linked container called 'solr' was not found"
    fi
  fi
  write_config
fi
