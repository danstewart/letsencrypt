#!/usr/bin/env bash

# certbot --manual-auth-hook script to copy the http challenge file to /path/to/.well-known/acme-challenge

domain=$CERTBOT_DOMAIN
filecontent=$CERTBOT_VALIDATION
filename=$CERTBOT_TOKEN

USER=''
TARGET_SERVER=''
TARGET_PATH='/path/to/.well-known/acme-challenge/'

echo $filecontent > $filename && scp $filename ${USER}@${TARGET_SERVER}:$TARGET_PATH
