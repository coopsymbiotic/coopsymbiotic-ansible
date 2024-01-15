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

Most hosts have a wrapper called `borg-mount` that can be called
with sudo (from privileged users). It only mounts folders relevant
to web users. For system files, the root user must mount manually
without any filters.

(see borgmatic docs, but having a quick reference here would be nice)

- mounting using fuse
- files changed in the past day?

## References

* https://torsion.org/borgmatic/docs/how-to/set-up-backups/
* https://lab.symbiotic.coop/coopsymbiotic/ops/issues/126
