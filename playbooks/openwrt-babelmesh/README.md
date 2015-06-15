Configures an OpenWRT device to act as a relay in the Reseau Libre network  
http://www.reseaulibre.ca

THIS IS HIGHLY EXPERIMENTAL, USE AT YOUR OWN RISK.

NB: not managed by the playbook, is:

- opkg install radvd tinc babeld ip tcpdump
- remove/disable the firewall (opkg remove firewall).. or set outbound only?
- most importantly: ip6tables -P FORWARD ACCEPT

Example host_var configuration:

```
radio0_channel: 1
radio0_hwmode: 11na
radio0_macaddr: 00:01:02:03:04:05

lan_dns: 2607:abcd:abcd:2900:1
lan_ip6addr: fd12:1234:1234:1234::1/60

mesh_ssid: myname.relais.reseaulibre.ca
mesh_network: mesh

ap_ssid: FORUM v99 reseaulibre.ca
ap_network: ap

ap_dns: 2607:abcd:abcd:2900:1
ap_ip6addr: fd12:1234:1234:1234::1/64
ap_ipaddr: 192.168.79.1
ap_netmask: 255.255.255.0

znet_ssid: INET v99 reseaulibre.ca
znet_network: znet
znet_key: mypassword

znet_dns: 192.168.99.1
znet_ip6addr: 2607:abcd:abcd:abcd::1/64
znet_ipaddr: 192.168.80.1
znet_netmask: 255.255.255.0
```
