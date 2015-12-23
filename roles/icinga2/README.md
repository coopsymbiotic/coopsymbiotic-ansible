### Icinga2 role

Installs the basic packages for icinga v2. Does not install the web interface,
which I strongly recommend (includes icingacli). Supports Debian and Ubuntu.

To use this role, assign the "icinga-servers" group to a server in your inventory.
You can also use a "icinga-nodes" group for monitored nodes, but this is mostly to
simplify the deployment. The playbook only checks if a server is in "icinga-servers"
or not, in order to determine whether to configure the node as a server or satellite.

### TODO

* The configuration of the server is missing some bits to configure icingaweb2.

* Master server should include zones.d/* (see icinga2.conf and uncomment the line).

### How to declare services for satellite nodes

For example, to monitor available disk space on satellite nodes, add this to /etc/icinga2/conf/services.conf:

```
apply Service "disk" {
  check_command = "disk"

  /* make sure host.name is the same as endpoint name */
  command_endpoint = host.name

  assign where "icinga-satellites" in host.groups
}
```

NB: This assumes that your satellite nodes are in the "icinga-satellites" hostgroup.

Example:

```
object Host "foo-node.example.org" {
  import "generic-host"

  groups = [ "icinga-satellites" ]

  address = "[...]"
  address6 = "[...]"
  check_command = "ping"
}
```

I haven't found a way to automate adding a server to the correct hostgroup (with Ansible). Might be simpler to find a way to detect remote nodes.

### References

* http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/icinga2-client

* http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/troubleshooting

* https://github.com/Icinga/puppet-icinga2/blob/develop/manifests/pki/icinga.pp

* http://serverfault.com/questions/647805/how-to-set-up-icinga2-remote-client-without-using-cli-wizard

* https://lists.icinga.org/pipermail/icinga-users/2015-October/010337.html
