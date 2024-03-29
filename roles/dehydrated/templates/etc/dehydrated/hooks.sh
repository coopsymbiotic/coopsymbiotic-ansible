#!/bin/bash

# {{ ansible_managed }}

# Source: https://alexschroeder.ch/wiki/2016-05-31_letsencrypt.sh_instead
# and https://github.com/lukas2511/dehydrated/blob/master/docs/examples/hook.sh

deploy_cert() {
    local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}" TIMESTAMP="${6}"

    if [ -x /usr/sbin/apache2ctl ]; then
      echo " + Hook: Reloading Apache configuration..."
      systemctl reload apache2
    elif [ -x /usr/sbin/apachectl ]; then
      echo " + Hook: Reloading Apache configuration..."
      apachectl graceful
    fi

    if [ -x /usr/sbin/nginx ]; then
      echo " + Hook: Reloading Nginx configuration..."
      systemctl reload nginx
    fi

    if [ -x /usr/sbin/postfix ]; then
      echo " + Hook: Reloading Postfix configuration..."
      systemctl reload postfix
    fi

    if [ -x /usr/bin/doveadm ]; then
      echo " + Hook: Reloading Dovecot configuration..."
      # Service has no reload
      /usr/bin/doveadm reload
    fi

    # https://wiki.zimbra.com/wiki/Installing_a_LetsEncrypt_SSL_Certificate
    if [ -x /opt/zimbra/bin/zmcontrol ]; then
      echo " + Hook: Deploying certificate in Zimbra..."
      cat /etc/dehydrated/keys/ISRG-X1.pem /etc/dehydrated/keys/${DOMAIN}/fullchain.pem > /opt/zimbra/ssl/dehydrated/root-and-fullchain.pem
      cp /etc/dehydrated/keys/${DOMAIN}/{cert,fullchain,privkey}.pem /opt/zimbra/ssl/dehydrated/
      chown zimbra.zimbra /opt/zimbra/ssl/dehydrated/*.pem
      sudo -i -u zimbra zmcertmgr verifycrt comm /opt/zimbra/ssl/dehydrated/privkey.pem /opt/zimbra/ssl/dehydrated/cert.pem /opt/zimbra/ssl/dehydrated/root-and-fullchain.pem
      cp /opt/zimbra/ssl/dehydrated/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
      sudo -i -u zimbra zmcertmgr deploycrt comm /opt/zimbra/ssl/dehydrated/cert.pem /opt/zimbra/ssl/dehydrated/root-and-fullchain.pem
      sudo -i -u zimbra zmcontrol restart
    fi

    # For civicrm.org
    if [ -f /etc/systemd/system/ldapcivi.service ]; then
      echo " + Hook: Restarting ldapcivi"
      systemctl restart ldapcivi
    fi
}

unchanged_cert() {
    echo " + Hook: Nothing to do..."
}

deploy_challenge() {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"

    # This hook is called once for every domain that needs to be
    # validated, including any alternative names you may have listed.
    #
    # Parameters:
    # - DOMAIN
    #   The domain name (CN or subject alternative name) being
    #   validated.
    # - TOKEN_FILENAME
    #   The name of the file containing the token to be served for HTTP
    #   validation. Should be served by your web server as
    #   /.well-known/acme-challenge/${TOKEN_FILENAME}.
    # - TOKEN_VALUE
    #   The token value that needs to be served for validation. For DNS
    #   validation, this is what you want to put in the _acme-challenge
    #   TXT record. For HTTP validation it is the value that is expected
    #   be found in the $TOKEN_FILENAME file.
}

clean_challenge() {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"

    # This hook is called after attempting to validate each domain,
    # whether or not validation was successful. Here you can delete
    # files or DNS records that are no longer needed.
    #
    # The parameters are the same as for deploy_challenge.
}

startup_hook() {
    echo " + Hook: startup"
}

exit_hook() {
    echo " + Hook: exit"
}

invalid_challenge() {
    echo " + Hook: Challenge is invalid..."
}

request_failure() {
    echo " + Hook: Request failed..."
}

HANDLER="$1"; shift
if [[ "${HANDLER}" =~ ^(deploy_challenge|clean_challenge|deploy_cert|unchanged_cert|invalid_challenge|request_failure|startup_hook|exit_hook)$ ]]; then
  "$HANDLER" "$@"
fi
