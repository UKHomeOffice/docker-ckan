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

  exec httpd -D FOREGROUND
else
  exec bash -c "$@"
fi
