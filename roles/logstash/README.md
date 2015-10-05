Misc notes:

* See tasks/main.yml, it's rather self-documented.

* For Kibana, this role will install an nginx vhost that is htpasswd protected. The password will be stored in /root/kibana-password.

* nginx patterns from : https://www.digitalocean.com/community/tutorials/adding-logstash-filters-to-improve-centralized-logging

* apache access log format is vhost_combined, which has host:ip as the first field. I'm not sure if this is the default Debian Jessie format, or Aegir config.
