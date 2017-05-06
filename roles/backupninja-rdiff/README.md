Backupninja and rdiff-backup
============================

This role configures rdiff-backup on a client machine, using backupninja.

It will also create the backup user on the backup server and deploy the ssh public key.

Restoring files
---------------

Find the backup server login and hostname by looking in `/etc/backup.d/90.rdiff`:

```
# grep -E '^(host|user|dir)' /etc/backup.d/90.rdiff
directory = /backup/foo.symbiotic.coop/rdiff-backup
host = backups.example.org
user = backups-foo
```

See files changed in the past day:

```
# rdiff-backup --list-changed-since 1D backups-foo@backups.example.org::/backup/foo.symbiotic.coop/rdiff-backup/var/backups/mysql/sqldump/
changed var/backups/mysql/sqldump/example.sql
```

To restore the last version of a specific file:

```
# rdiff-backup --restore-as-of now backups-foo@backups.example.org::/backup/foo.symbiotic.coop/rdiff-backup/var/backups/mysql/sqldump/example.sql /root/restore/example.sql
```

To restore a file from 2 days (2D) ago:

```
# rdiff-backup --restore-as-of 2D backups-foo@backups.example.org::/backup/foo.symbiotic.coop/rdiff-backup/var/backups/mysql/sqldump/example.sql /root/restore/example.sql
```
