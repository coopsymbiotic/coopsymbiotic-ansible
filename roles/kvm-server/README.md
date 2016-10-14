kvm-server
==========

Role to configure KVM servers (to host virtual-machines).

ZFS setup
---------

Assuming the server has been setup with minimal RAID-1 15GB partitions to boot and that the rest has not been allocated (ex: https://wiki.symbiotic.coop/serveurs/x2.symbiotic.coop).

Pool setup:

* create new extended partition on both disks with cfdisk
* create new regular linux partition on both disks (/dev/sdX5) with cfdisk
* run "partprobe"
* create a new pool: zpool create -f zxNN mirror /dev/sda5 /dev/sdb5

NB: in the above, NN is the 'x' number. Ex: the pool on x2.symbiotic.coop is zx2.

Create partitions for the VMs:

* create new partitions:
* zfs create -V 50G zx2/av201
* zfs create -V 25G zx2/ddm
* zfs create -V 25G zx2/smtp

# New VM creation:
# av201
# virt-install --name av201 --ram 8192 --disk path=/dev/zvol/zx2/av201 --vcpus 4 --os-type linux --os-variant virtio26 --network bridge=br0 --graphics vnc,listen=127.0.0.1 --noautoconsole --location 'http://ftp.ca.debian.org/debian/dists/jessie/main/installer-amd64/' --extra-args 'ks=file:/av201.ks' --initrd-inject=/root/av201.ks
#

