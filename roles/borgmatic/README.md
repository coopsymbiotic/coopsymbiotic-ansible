# borgmatic

This role configures borg backups on a client machine, using borgmatic.

It will also create the backup user on the backup server and deploy the ssh public key.

## Exclude directories from backups

Go to the directory you wish to exclude and create a `.nobackup` file.

Example:

```
cd /path/to/foo-tmp
touch .nobackup
```

## Restoring files

As root on the client server, find the backup server login and hostname by
looking in `/etc/borgmatic/config.yaml`:

```
# grep -E '^(host|user|dir)' /etc/backup.d/90.rdiff
directory = /backup/foo.symbiotic.coop/rdiff-backup
host = backups.example.org
user = backups-foo
```

See files changed in the past day:

```
# TODO (example command)
(example output)
```

To restore the last version of a specific file:

```
# (example command)
```

To restore a file from 2 days (2D) ago:

```
# (example command)
```

## References

* https://torsion.org/borgmatic/docs/how-to/set-up-backups/
* https://lab.symbiotic.coop/coopsymbiotic/ops/issues/126
