Elasticsearch/Logstash/Kibana (ELK)
===================================

Purging old logs
----------------

This should probably be in cron?

```
---
# FILE: /root/el-delete.yml
# Remember, leave a key empty if there is no value.  None will be a string,
# not a Python "NoneType"
#
# Also remember that all examples have 'disable_action' set to True.  If you
# want to use this action as a template, be sure to set this to False after
# copying it.
actions:
  1:
    action: delete_indices
    description: >-
      Delete indices older than 60 days (based on index name), for logstash-
      prefixed indices. Ignore the error if the filter does not result in an
      actionable list of indices (ignore_empty_list) and exit cleanly.
    options:
      ignore_empty_list: True
      timeout_override:
      continue_if_exception: False
      disable_action: False
    filters:
    - filtertype: age
      source: name
      direction: older
      timestring: '%Y.%m.%d'
      unit: days
      unit_count: 60
      exclude:

```

```
curator /root/el-delete.yml
```

Misc notes
----------

* For Kibana, this role will install an nginx vhost that is htpasswd protected. The password will be stored in /root/kibana-password.
* nginx patterns from : https://www.digitalocean.com/community/tutorials/adding-logstash-filters-to-improve-centralized-logging
* apache access log format is vhost_combined, which has host:ip as the first field. I'm not sure if this is the default Debian Jessie format, or Aegir config.

Forwarding logs from OpenWRT
----------------------------

For example, in /etc/config/system :

```
option log_ip 1.2.3.4
option log_port 5544
option log_remote 1
option conloglevel 6
```

Then either reboot or restart syslog manually (since OpenWRT BB: /etc/init.d/log restart).

TODO Beats
----------

```
cd /opt/logstash
./bin/plugin install logstash-input-beats
```
