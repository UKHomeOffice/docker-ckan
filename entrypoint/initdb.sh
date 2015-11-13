#!/usr/bin/env bash

set -eu

paster --plugin=ckan db init -c "${CKAN_CONFIG}/ckan.ini"
