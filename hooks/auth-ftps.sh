#!/usr/bin/env bash

# certbot --manual-auth-hook script to copy the http challenge file to /path/to/.well-known/acme-challenge

domain=$CERTBOT_DOMAIN
filecontent=$CERTBOT_VALIDATION
filename=$CERTBOT_TOKEN

FTP_USER=''
FTP_PASS=''
FTP_HOST=''

# Create the file locally then upload it to the FTP
echo "$filecontent" > "$filename"
lftp -c "set ftp:ssl-allow true; set ssl:ca-file '$BASE_DIR/auth/ftps.crt'; open -u $FTP_USER,$FTP_PASS -e 'mput $filename; quit;' $FTP_HOST"
