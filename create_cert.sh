#!/usr/bin/env bash

# Wrapper script around cerbot

# Usage
function usage() {
	echo "Usage: CONNECT_TYPE=ftps|ssh|s3 ./create_cert.sh <domain> [--dry-run] [--whatever]"
	exit
}

domain="$1"
if [[ -z "$domain" ]]; then
	usage
else
	shift # shift off the domain so we can slurp the other args
fi

if [[ -z "$CONNECT_TYPE" ]]; then
	echo '$CONNECT_TYPE is not set'
	usage
fi

# Here we go...
EMAIL='changeme@example.com' # CHANGE ME!
export BASE_DIR="$(dirname $(realpath -s "$0"))"
AUTH_HOOK="$BASE_DIR/hooks/auth-${CONNECT_TYPE}.sh"
CLEAN_HOOK="$BASE_DIR/hooks/clean-${CONNECT_TYPE}.sh"
WORK_DIR="$BASE_DIR/certs/"
CONFIG_DIR="$BASE_DIR/certs/"
LOG_DIR="$BASE_DIR/certs/"

OTHER_FLAGS=$*

# If the specified site starts with www. then generate for both www.$domain and $domain
base_domain="${domain/www\./}"
extra_domains=""

# NOTE: Might just remove this and expect the caller to run twice
if [[ $domain != $base_domain ]]; then
	extra_domains="--domain $base_domain"
fi

# Run certbot
certbot certonly --manual --domain "$domain" $extra_domains --email "$EMAIL" --preferred-challenges http --work-dir "$WORK_DIR" --config-dir "$CONFIG_DIR" --logs-dir "$LOG_DIR" --manual-public-ip-logging-ok --agree-tos --no-eff-email --noninteractive --manual-auth-hook "$AUTH_HOOK" --manual-cleanup-hook "$CLEAN_HOOK" $OTHER_FLAGS

# certbot ran successfully, combine the cert and key then put it on the haproxy server
if [[ $? == 0 ]]; then
	cert_dir="$BASE_DIR/certs/live/$domain"

	# If we actually generated a cert then combine it and upload to the certificates bucket
	if [[ -d "$cert_dir" && -f "$cert_dir/fullchain.pem" && -f "$cert_dir/privkey.pem" ]]; then
		cat "$cert_dir/privkey.pem" "$cert_dir/fullchain.pem" > "$cert_dir/${domain}.cer"

		export AWS_ACCESS_KEY_ID=$(head -1 "$BASE_DIR/auth/aws_security_s3.key")
		export AWS_SECRET_ACCESS_KEY=$(tail -1 "$BASE_DIR/auth/aws_security_s3.key")
		export AWS_DEFAULT_REGION="eu-west-1"

		# Put the cert onto the security services certificates bucket
		aws s3 cp "$cert_dir/${domain}.cer" "s3://bucket/sslcerts/prod/${domain//\./_}.cer"
	fi
fi
