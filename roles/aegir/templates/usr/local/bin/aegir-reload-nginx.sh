#!/bin/sh

# This is a workaround script so that we can safely call it with sudo
# and because on Debian10, mysteriously, "systemctl reload nginx" ends
# up exiting nginx if there is a syntax error.
/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
