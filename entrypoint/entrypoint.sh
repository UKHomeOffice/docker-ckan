#!/usr/bin/env bash

if [ $# -eq 0 ] ; then
  . "${CKAN_HOME}/bin/activate"
fi

set -eu

if [ $# -eq 0 ] ; then

  "${ENTRYPOINT_SCRIPT_HOME}/configure.sh"


  shopt -s nullglob
  for SUBDIR in ${CKAN_PLUGINS}/* ; do
    if [[ -d "${SUBDIR}" ]]; then
      (cd "${SUBDIR}" && python "setup.py" develop)
    fi
  done
  shopt -u nullglob

  (cd "${CKAN_HOME}" && python "setup.py" develop)
  "${ENTRYPOINT_SCRIPT_HOME}/initdb.sh"

  shopt -s nullglob
  for USER_SCRIPT in ${USER_SCRIPT_DIR}/* ; do
    if [[ -x "${USER_SCRIPT}" ]]; then
      "${USER_SCRIPT}"
    fi
  done
  shopt -u nullglob

#generate ssl self-signed ssl certs.
    if [ "$(ls -A /etc/httpd/ssl/)" ]; then
      echo 'Certificates already mounted'
    else
      /docker/gencert.sh ${DOMAIN:-localhost}
    fi

    if [[ -r "/etc/ckan/default/ckan.ini" ]]; then
      paster --plugin=ckan search-index rebuild -r --config=/etc/ckan/default/ckan.ini
    fi

#get db creds from file if they exist

if [ -z ${DB_CREDS+x} ]; then
  echo "DB_CREDS is unset, skipping";
else
  source /docker/db_creds.sh
fi

  exec httpd -D FOREGROUND
else
  exec bash -c "$@"
fi
