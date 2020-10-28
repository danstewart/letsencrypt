## Usage
```
CONNECT_TYPE=s3|ftps|ssh ./create_cert.sh <domain> [--dry-run] [--additional-flags]
```
Any `--additional-flags` will be passed to certbot.  

### Dependencies
- cerbot
- awscli

### Overrides
`CONNECT_TYPE` can be either `ftps`, `ssh` or `s3` - This will use that method of connecting to the servers

Example:
```
CONNECT_TYPE=s3 ./create_cert.sh <domain> [--dry-run] [--additional-flags]
```

These vars control which `hooks/` scripts will be ran (ie. we will run `hooks/auth-${CONNECT_TYPE}.sh` and `hooks/clean-${CONNECT_TYPE}.sh`).  

---

## About
`create_cert.sh` is a wrapper around `certbot` that will accept all options (TOS & IP logging) and run an auth hook to put the http challenge key on `.well-known/acme-challenge/` (either a file path with ssh/ftps or an s3 bucket with s3) and then a clean hook to delete it afterwards.

We then combine the cert and key and put it in the certificates bucket on the security account.  

> NOTE: This will generate a cert for both domain.com and www.domain.com

---

#### Renewal

Just rerun this and it will renew any certificates due for renewal - otherwise it will exit.

---

#### Caveats and notes
- To be fully automatic in SSH mode you need to have ssh key authentication set up to the target server
- I had to `chmod 777 /path/to/.well-known/acme-challenge/` to allow `scp-auth.sh` to `scp` the file to it under my own user
- The ftps user should upload directly to `/path/to/.well-known/acme-challenge/`

---

#### TODO
- Add wrapper script to run for all clients that need a cert
- Move security keys out of repo
- Look into wildcard support (DNS challenge) - see [here](https://medium.com/@saurabh6790/generate-wildcard-ssl-certificate-using-lets-encrypt-certbot-273e432794d7)

---

#### Useful links
- [manual mode](https://certbot.eff.org/docs/using.html#manual)
- [http challenge](https://certbot.eff.org/docs/challenges.html?highlight=http)
- [hooks](https://certbot.eff.org/docs/using.html#hooks)
- [CLI options](https://certbot.eff.org/docs/using.html#certbot-command-line-options)
