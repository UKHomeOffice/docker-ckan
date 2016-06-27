#!/usr/bin/env bash
set -eu

#echo "var is set to '$DB_CREDS'";
AWS_ACCESS_KEY_ID=$(cat $S3_CREDS | sed -n 1p | cut -d ":" -f 2 | tr -d '[[:space:]]')
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$(cat $S3_CREDS | sed -n 2p | cut -d ":" -f 2 | tr -d '[[:space:]]')
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
S3_USER=$(cat $S3_CREDS | sed -n 3p | cut -d ":" -f 2 | tr -d '[[:space:]]')
export S3_USER=$S3_USER
echo "updated S3 Creds to environment variables"
