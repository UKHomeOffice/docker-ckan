#!/usr/bin/env bash
. "${CKAN_HOME}/bin/activate"

set -eu


paster --plugin=ckan db init -c "${CKAN_CONFIG}/ckan.ini"
