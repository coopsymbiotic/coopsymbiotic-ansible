Installs the basic packages for icinga v2. Does not install the web interface,
which I strongly recommend (includes icingacli).

To use this role, assign the "icinga-servers" group to a server in your inventory.
You can also use a "icinga-nodes" group for monitored nodes, but this is mostly to
simplify the deployment. The playbook only checks if a server is in "icinga-servers"
or not, in order to determine whether to configure the node as a server or satellite.

References:

* http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/icinga2-client

* http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/troubleshooting

* https://github.com/Icinga/puppet-icinga2/blob/develop/manifests/pki/icinga.pp

* http://serverfault.com/questions/647805/how-to-set-up-icinga2-remote-client-without-using-cli-wizard

* https://lists.icinga.org/pipermail/icinga-users/2015-October/010337.html
