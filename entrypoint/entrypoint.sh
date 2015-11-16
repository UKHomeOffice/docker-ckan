#!/usr/bin/env bash
. "${CKAN_HOME}/bin/activate"

set -eu

if [ $# -eq 0 ] ; then

  "${ENTRYPOINT_SCRIPT_HOME}/configure.sh"

  shopt -s nullglob

  for USER_SCRIPT in $USER_SCRIPT_DIR/* ; do
    if [[ -x "${USER_SCRIPT}" ]]; then
      "${USER_SCRIPT}"
    fi
  done

  shopt -u nullglob

  "${ENTRYPOINT_SCRIPT_HOME}/initdb.sh"
  exec httpd -D FOREGROUND
else
  exec $@
fi
