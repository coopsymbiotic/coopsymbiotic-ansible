Ansible playbooks for Coop SymbioTIC
====================================

Ansible playbooks for the Coop SymbioTIC (https://www.symbiotic.coop).

We provide CiviCRM-based services for non-profits, professional associations,
unions and small-medium size companies. We are a worker's coop based in
Montreal, Quebec (Canada).

Our Ansible roles/playbooks are published in the hope that they can be useful.
Use at your own risk.

We are grateful to the Ansible community, but also to all the communities of
each project we use, such as CiviCRM, Icinga, Aegir and others, either for their
help on IRC, online documentation, etc. We hope to "push it forward" by also
contributing our experiences for others to learn from.

Feedback/suggestions welcome. Please use the Github issue queue of this project.
You can also contact us at info (at) symbiotic.coop.

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

    ansible-playbook site.yml --list-hosts

Run the playbook:

    ansible-playbook site.yml

Run it on a specific node:

    ansible-playbook -l foo.example.org site.yml

Run only a specific role (each role is tagged in site.yml):

    ansible-playbook --tags=ufw site.yml

Run 10 "things" (servers?) in parallel:

    ansible-playbook site.yml -f 10
