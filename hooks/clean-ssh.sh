#!/usr/bin/env bash

# certbot --manual-cleanup-hook script to delete the http challenge file from /path/to/.well-known/acme-challenge

filename=$CERTBOT_TOKEN

USER=''
TARGET_SERVER=''
TARGET_PATH='/path/to/.well-know/acme-challenge/'

ssh ${USER}@${TARGET_SERVER} "rm -f ${TARGET_PATH}${filename}"

# Delete the file locally too
rm $filename
