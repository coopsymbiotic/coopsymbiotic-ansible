Ansible playbooks for bidon.ca
==============================

Ansible playbooks for my personnal servers (all running the latest stable version of Debian GNU/Linux).

WARNING: I have not done a lot of reading on Ansible. My playbooks are most
probably not a model for best practices. Copy-paste at your own risk.

Feedback/suggestions welcome. Please use the github issue queue.

New node bootstrap
------------------

Install required packages:

    apt-get install sudo openssh-server

Create the ansible deployment user:

    useradd -m -G sudo deploy

Copy the ssh key:

    mkdir /home/deploy/.ssh
    chown deploy:deploy /home/deploy/.ssh
    chmod 0700 /home/deploy/.ssh
    wget -O /home/deploy/.ssh/authorized_keys https://www.example.org/files/ansible-deploy.pub
    chown deploy.deploy /home/deploy/.ssh/authorized_keys

Configure sudo:

    visudo -f /etc/sudoers.d/deploy

Example:

    deploy   ALL=(ALL:ALL) NOPASSWD: ALL

Running a playbook
------------------

See what hosts would be affected by a playbook before you run it:

    ansible-playbook main.yml --list-hosts

Run the playbook:

    ansible-playbook main.yml

Run it on a specific node:

    ansible-playbook -l foo.example.org main.yml

Run 10 "things" (servers?) in parallel:

    ansible-playbook main.yml -f 10
