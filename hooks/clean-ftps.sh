#!/usr/bin/env bash

# certbot --manual-cleanup-hook script to delete the http challenge file from /path/to/.well-known/acme-challenge

filename=$CERTBOT_TOKEN

FTP_USER=''
FTP_PASS=''
FTP_HOST=''

# Delete the file from the ftps
lftp -c "set ftp:ssl-allow true; set ssl:ca-file '$BASE_DIR/auth/ftps.crt'; open -u $FTP_USER,$FTP_PASS -e 'rm $filename; quit;' $FTP_HOST"

# Delete the file locally too
rm $filename
