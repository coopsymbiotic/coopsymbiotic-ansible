# Gitlab

Minimal Gitlab install.

* Uses the upstream packages.
* Configures a daily backup job (excludes uploads).
* TODO: Generate/copy the dhparams key for nginx (see main.yml).

Backups should be picked up by the borgmatic role. The host_vars file
for this host should also have the following variables:

```
backupincludes:
  - /var/opt/gitlab/backups
  - /var/opt/gitlab/gitlab-rails/uploads

backupexcludes:
  - /var/opt/gitlab/prometheus/data_tmp
  - /var/opt/gitlab/prometheus/data
  - /var/opt/gitlab/postgresql
  - /var/opt/gitlab/gitlab-ci/builds
  - /var/opt/gitlab/nginx
  - /var/opt/gitlab/redis
  - /var/opt/gitlab/grafana
```

## Internal Symbiotic references

* https://lab.symbiotic.coop/coopsymbiotic/ops/-/wikis/Gitlab/0_intro
* https://lab.symbiotic.coop/coopsymbiotic/ops/-/wikis/Gitlab/Installation
