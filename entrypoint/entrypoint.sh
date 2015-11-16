#!/usr/bin/env bash

set -eu

if [ $# -eq 0 ] ; then
  "${ENTRYPOINT_SCRIPT_HOME}/configure.sh"
  "${ENTRYPOINT_SCRIPT_HOME}/initdb.sh"

  shopt -s nullglob

  for USER_SCRIPT in $USER_SCRIPT_DIR/* ; do
    if [[ -x "${USER_SCRIPT}" ]]; then
      "${USER_SCRIPT}"
    fi
  done

  shopt -u nullglob

  exec httpd -D FOREGROUND
else
  exec $@
fi
