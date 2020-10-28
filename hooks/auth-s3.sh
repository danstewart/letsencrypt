#!/usr/bin/env bash

# certbot --manual-auth-hook script to copy the http challenge file to AWS static bucket to .well-known/acme-challenge

domain=$CERTBOT_DOMAIN
filecontent=$CERTBOT_VALIDATION
filename=$CERTBOT_TOKEN

export AWS_ACCESS_KEY_ID=$(head -1 "$BASE_DIR/auth/aws_prod_s3.key")
export AWS_SECRET_ACCESS_KEY=$(tail -1 "$BASE_DIR/auth/aws_prod_s3.key")
export AWS_DEFAULT_REGION="eu-west-1"

# Create the file locally then upload it to the FTP
echo "$filecontent" > "$filename"
aws s3 cp -- "$filename" "s3://bucket/.well-known/acme-challenge/"
