Ansible playbooks for Coop SymbioTIC
====================================

Ansible playbooks for the Coop SymbioTIC (https://www.symbiotic.coop).

Our Ansible roles/playbooks are published in the hope that they can be useful.
Use at your own risk.

We provide turn-key CiviCRM-based services for non-profits, professional
associations, unions and small-medium size companies. We are a worker's
coop based in Montreal, Quebec (Canada).

Looking for CiviCRM services? Would you like to join our team?
Contact us at info (at) symbiotic.coop.

Feedback/suggestions welcome. Please use the Github issue queue of this project
for technical issues.

Requirements
------------

The server from where you will be running Ansible must have Ansible >= 2.0 on Debian 9.

Git clone this repo with submodules
-----------------------------------

This set of Ansible playbooks/roles includes submodules. Make sure you clone recursively:

```
git clone --recursive https://github.com/coopsymbiotic/coopsymbiotic-ansible.git
```

New node bootstrap
------------------

Assuming the server already runs ssh and you have either ssh root access or a
user account that can sudo root:

1- Ensure that you have the private files in /etc/ansible/files

2- Add the host to the 'production' inventory (/etc/ansible/hosts).

3- Create, if necessary, the host_vars file for that host (/etc/ansible/host_vars/example.symbiotic.coop)

4- Run the following setup:

```
ansible-playbook -l example.symbiotic.coop -u mathieu --become-user=root --ask-become-pass --ask-pass ./setup.yml
```

5- And finally the normal run:

```
ansible-playbook -l example.symbiotic.coop ./site.yml
```


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
