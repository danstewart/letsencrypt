#!/usr/bin/env bash

# certbot --manual-cleanup-hook script to delete the http challenge file from the static S3 bucket .well-known/acme-challenge

filename=$CERTBOT_TOKEN

export AWS_ACCESS_KEY_ID=$(head -1 "$BASE_DIR/auth/aws_prod_s3.key")
export AWS_SECRET_ACCESS_KEY=$(tail -1 "$BASE_DIR/auth/aws_prod_s3.key")
export AWS_DEFAULT_REGION="eu-west-1"

# Delete the file S3
aws s3 rm "s3://bucket/.well-known/acme-challenge/$filename"

# Delete the file locally too
rm $filename
