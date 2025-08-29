#!/bin/bash

# Begin the installation of the VM
virt-install --name {{ hostvars[item]['preseed_hostname'] }} \
  --ram {{ hostvars[item]['preseed_ram_mb'] }} \
  --disk path=/dev/zvol/{{ kvm_zfs_pool }}/{{ hostvars[item]['preseed_hostname'] }} \
  --cpu host-passthrough \
  --vcpus {{ hostvars[item]['preseed_vcpus'] }} --os-variant debian11 \
{% if hostvars[item]['preseed_macaddr'] is defined %}
  --network bridge=br0,mac={{ hostvars[item]['preseed_macaddr'] }} \
{% else %}
  --network bridge=br0 \
{% endif %}
  --graphics vnc,listen=127.0.0.1 \
  --noautoconsole --location 'http://ftp.ca.debian.org/debian/dists/trixie/main/installer-amd64/' \
  --autostart \
  --initrd-inject=/etc/preseeds/{{ hostvars[item]['preseed_hostname'] }}.{{ hostvars[item]['preseed_domain'] }}/preseed.cfg

# Make sure it boots automatically
# virsh autostart {{ hostvars[item]['preseed_hostname'] }}

# For VM migrations between hosts
# virt-install --name {{ hostvars[item]['preseed_hostname'] }} --ram {{ hostvars[item]['preseed_ram_mb'] }} --disk path=/dev/zvol/{{ kvm_zfs_pool }}/{{ hostvars[item]['preseed_hostname'] }} --cpu host-passthrough --vcpus {{ hostvars[item]['preseed_vcpus'] }} --os-variant debian11 {% if hostvars[item]['preseed_macaddr'] is defined %}--network bridge=br0,mac={{ hostvars[item]['preseed_macaddr'] }}{% else %}--network bridge=br0{% endif %} --graphics vnc,listen=127.0.0.1 --noautoconsole --boot hd --import --autostart

# Based on:
# https://serverfault.com/questions/385889/kvm-guest-auto-start-after-install

finished="0"

while [ "$finished" = "0" ]; do
        sleep 5;
        virsh list --all | grep "running" | grep -q "{{ hostvars[item]['preseed_hostname'] }}"
        if [[ $? != 0 ]]; then
                echo "Setup finished, starting vm {{ hostvars[item]['preseed_hostname'] }}"
                finished=1
                virsh start {{ hostvars[item]['preseed_hostname'] }}
        fi
done
