#!/usr/bin/env bash

set -eu

if [ $# -eq 0 ] ; then
  "${ENTRYPOINT_SCRIPT_HOME}/configure.sh"
  "${ENTRYPOINT_SCRIPT_HOME}/initdb.sh"

  shopt -s nullglob

  for USER_SCRIPT in $USER_SCRIPT_DIR/*.{sh,bash} ; do
    "${USER_SCRIPT}"
  done

  shopt -u nullglob

  exec httpd -D FOREGROUND
else
  exec $@
fi
