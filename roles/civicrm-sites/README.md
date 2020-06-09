# CiviCRM Sites

Work-in-progress role for setting up CiviCRM sites.

## Setting up extra crons

Either in `groups/all` or `host_vars/[host]`, we can define more specific crons
(todo: the base CMS and CiviCRM crons should automatically be created as part
of the base setup).

For example:

```
civicrm_sites_extra_crons:
  mycron:
    user: www-data
    description: Description of the cron
    exec: "drush @{{ inventory_hostname }} -u 1 cvapi Job.update_something"
    on_unit_inactive_sec: 15m
    randomized_delay_sec: 15s
  anothercron:
    [...]
```

You can inspect the status of systemd timers with:

```
# systemctl list-timers --all
NEXT                         LEFT          LAST                         PASSED    UNIT                              ACTIVATES
Tue 2020-06-09 14:14:40 EDT  13min left    n/a                          n/a       civicrm_chcontribs_test-dms.timer civicrm_chcontribs_test-dms.service
[...]
```

We can also review the last output of the cron run:

```
# systemctl status civicrm_mycron_site1.timer
● civicrm_mycron_site1.timer - "My description"
   Loaded: loaded (/etc/systemd/system/civicrm_mycron_site1.timer; enabled; vendor preset: enabled)
   Active: active (waiting) since Tue 2020-06-09 14:01:03 EDT; 1min 31s ago
  Trigger: Tue 2020-06-09 14:14:40 EDT; 12min left

Jun 09 14:01:03 aegir systemd[1]: Started "My Description".
```

Tail a specific cron (to see when it runs, but it will not display the output):

```
# journalctl -f -u civicrm_mycron_site1.timer
```

Tail the service and see the output:

```
# journalctl -f -u civicrm_mycron_site1.service
Jun 09 14:34:38 aegir systemd[1]: Started "My Description".
Jun 09 14:34:38 aegir drush[11706]: Array
Jun 09 14:34:38 aegir drush[11706]: (
Jun 09 14:34:38 aegir drush[11706]:     [is_error] => 0
Jun 09 14:34:38 aegir drush[11706]:     [version] => 3
Jun 09 14:34:38 aegir drush[11706]:     [count] => 1
Jun 09 14:34:38 aegir drush[11706]:     [values] => 1
Jun 09 14:34:38 aegir drush[11706]: )
Jun 09 14:34:38 aegir systemd[1]: civicrm_mycron_site1.service: Succeeded.
```

You cannot force a specific timer to run immediately (ex: to test it), but you can run the service associated with it:

```
systemctl start civicrm_mycron_site1.service
```

References:

* https://wiki.archlinux.org/index.php/Systemd/Timers
* https://medium.com/horrible-hacks/using-systemd-as-a-better-cron-a4023eea996d
